Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab0LCP3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:29:07 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:57523 "EHLO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0LCP3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:29:06 -0500
Message-ID: <4CF90CBD.9090204@ge.com>
Date: Fri, 03 Dec 2010 15:29:01 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/vme_user: add missing calls to vme_master_free
 calls in .remove
References: <1288055476-19438-26-git-send-email-cota@braap.org> <20101203142051.17155.30135.stgit@ES-BJ21R4J> <20101203144412.GA32222@kroah.com>
In-Reply-To: <20101203144412.GA32222@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2010 15:29:04.0100 (UTC) FILETIME=[D14CA240:01CB92FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/10 14:44, Greg KH wrote:
> On Fri, Dec 03, 2010 at 02:20:51PM +0000, Martyn Welch wrote:
>> From: Emilio G. Cota <cota@braap.org>
>>
>> Signed-off-by: Emilio G. Cota <cota@braap.org>
>> Acked-by: Martyn Welch <martyn.welch@ge.com>
>> ---
> 
> Does this need to be in .37 or can it wait for .38?
> 

Given that this is in the vme_user device in the staging tree, I think
it can safely wait until .38.

Martyn

> thanks,
> 
> greg k-h


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
