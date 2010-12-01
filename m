Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0LARHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:07:30 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:47401 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0LARH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:07:28 -0500
X-Greylist: delayed 829 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 12:07:28 EST
Message-ID: <4CF68087.2090802@csr.com>
Date: Wed, 01 Dec 2010 17:06:15 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: whci-hcd: fix compiler warning
References: <1291177721-17598-1-git-send-email-namhyung@gmail.com>	 <20101201161039.GB29318@suse.de> <1291222151.1684.46.camel@leonhard>	 <4CF67D5F.3080609@csr.com> <1291222944.1684.48.camel@leonhard>
In-Reply-To: <1291222944.1684.48.camel@leonhard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Dec 2010 17:06:15.0889 (UTC) FILETIME=[107D8410:01CB917A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim wrote:
> 2010-12-01 (수), 16:52 +0000, David Vrabel:
>> Namhyung Kim wrote:
>>> I saw it during allyesconfig build but not on allmodconfig.
>>> Maybe we can wrap it up in #ifdef CONFIG_MODULES ?
>> That might be best.  Can you do the same with drivers/uwb/whc-rc.c?  It
>> will have the same problem.
>>
>> David
> 
> No problem. Will send them soon. :)

Actually CONFIG_MODULES is wrong. It needs to test if the driver has
been built as a module or not.  I think there's a __MODULE__ or MODULE
#define for this, not sure though.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
