Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396Ab2AFPuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:50:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57938 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758750Ab2AFPuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:50:15 -0500
User-Agent: Microsoft-Entourage/12.32.0.111121
Date: Fri, 06 Jan 2012 15:50:04 +0000
Subject: Re: [Xen-devel] [PATCH 4/5] xen/pciback: Expand the warning message
 to include domain id.
From: Keir Fraser <keir@xen.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: <linux-pci@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>
Message-ID: <CB2CC8AC.36FD5%keir@xen.org>
Thread-Topic: [Xen-devel] [PATCH 4/5] xen/pciback: Expand the warning message
 to include domain id.
Thread-Index: AczMitsU40GbprNDNUy/g9RSFnMGSg==
In-Reply-To: <20120106150338.GB5855@phenom.dumpdata.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 15:03, "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com> wrote:

>> As you're touching this anyway, how about fixing the other minor
>> issues with it too? E.g.
>> 
>> dev_err(&dev->dev, "Device appears to be assigned to dom%d!"
>> " Overwriting the ownership, but beware.\n",
>> xen_find_device_domain_owner(dev));
>> 
>> (a native English speaker may want to comment the "but beware"
>> part - it reads odd for me).
> 
> Hm, lets ask the English speakers. Ian?

The suggested reworking above is an improvement. The "but beware" bit is
fine.

 -- keir


