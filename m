Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1CHKvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:51:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35848 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1CHKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tN0MZ6Mwdmt4VPctXbOwFSDAedJXUt2xL5feiWo3Ts7pfZqVZL+okfj3ThcaekiQYS
         qaWJdlaPeUY0zQGiXkcAY+oFZXEbCGNEtuuF8XFb5mllafRxsY3dFQ+919pqv3joeTXQ
         0O3LrWrRnNz3PfZwHV+dY8fBx+cjc8cO7UcEA=
Message-ID: <4D760A36.5040206@gmail.com>
Date: Tue, 08 Mar 2011 11:51:34 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Slaby <jslaby@suse.cz>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: eeepc: rfkill on 900A defunct
References: <4CED26EF.5000109@suse.cz>	<20101124201834.GA7760@srcf.ucam.org>	<4D6B6F9A.1020102@gmail.com>	<4D75FF8E.9010103@gmail.com> <AANLkTinBRCdOa1QdvWJiihvBpmJyvmRvDoFYgp0yTMFc@mail.gmail.com>
In-Reply-To: <AANLkTinBRCdOa1QdvWJiihvBpmJyvmRvDoFYgp0yTMFc@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 11:22 AM, Corentin Chary wrote:
> On Tue, Mar 8, 2011 at 10:06 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 02/28/2011 10:49 AM, Jiri Slaby wrote:
>>> On 11/24/2010 09:18 PM, Matthew Garrett wrote:
>>>> Hm. As a shorter term fix, can you try this (entirely untested!)
>>>> approach?
>>>
>>> What is the status of this? Was there any alternative merged?
>>
>> Ping.
> 
> Because this is Matthew's patch, and I have no hardware to test that
> patch, I'm not touching it.
> 
> Jiri, on what models was this patch tested (only got 701 and 901 here) ?

It was 900A.

thanks,
-- 
js
