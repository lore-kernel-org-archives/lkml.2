Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab1HXHkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:40:42 -0400
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:52224 "EHLO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1HXHki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:40:38 -0400
Message-ID: <4E54AAF2.4050102@ge.com>
Date: Wed, 24 Aug 2011 08:40:34 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Manohar Vanga <manohar.vanga@cern.ch>, gregkh@suse.de, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] [RESEND v2] VME Framework Fixes
References: <1313145051-13397-1-git-send-email-manohar.vanga@cern.ch> <20110823221443.GC15721@kroah.com>
In-Reply-To: <20110823221443.GC15721@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Aug 2011 07:40:36.0981 (UTC) FILETIME=[1D34A250:01CC6231]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/11 23:14, Greg KH wrote:
> On Fri, Aug 12, 2011 at 12:30:46PM +0200, Manohar Vanga wrote:
>> Hi Martyn,
>>
>> This is the updated list of patches. I have removed the bus numbering
>> patch as we can work on it further before adding it in. Some notes on
>> the various patches below:
>>
>>   staging: vme: make [alloc|free]_consistent bridge specific
> 
> I've applied the first 2 only.
> 
> Martyn, my vme patch queue is now empty, if I have missed anything I
> should have applied, please resend it and let me know.
> 
> thanks,
> 
> greg k-h

Thanks Greg, I think that's all the patches that have been agreed so far. I
believe that Manohar is working on a few issues that were found in some of the
other patches.

Martyn

-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)1327322748                         | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
