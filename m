Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1CHKWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:22:42 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42611 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab1CHKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:22:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Cn2jp8jKUETuBn9xeJLSPHXAFcqDRI29zI6eItFyxbkg0PZpsGAibYE/DjFf0OQvTi
         oDJkrNPfAfrlvLXGbvjJk70GA5TrltXUvwm3zpRXEFLV81ronOMm3S9YSRmVR89b1FfG
         rnMBNRsuC2PmkDTkz3LsZPfU2cWzACFYDhokU=
MIME-Version: 1.0
In-Reply-To: <4D75FF8E.9010103@gmail.com>
References: <4CED26EF.5000109@suse.cz>
	<20101124201834.GA7760@srcf.ucam.org>
	<4D6B6F9A.1020102@gmail.com>
	<4D75FF8E.9010103@gmail.com>
Date: Tue, 8 Mar 2011 10:22:38 +0000
Message-ID: <AANLkTinBRCdOa1QdvWJiihvBpmJyvmRvDoFYgp0yTMFc@mail.gmail.com>
Subject: Re: eeepc: rfkill on 900A defunct
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 10:06 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 02/28/2011 10:49 AM, Jiri Slaby wrote:
>> On 11/24/2010 09:18 PM, Matthew Garrett wrote:
>>> Hm. As a shorter term fix, can you try this (entirely untested!)
>>> approach?
>>
>> What is the status of this? Was there any alternative merged?
>
> Ping.

Because this is Matthew's patch, and I have no hardware to test that
patch, I'm not touching it.

Jiri, on what models was this patch tested (only got 701 and 901 here) ?
Matthew, will you merge this patch in your tree ?

Thanks,
-- 
Corentin Chary
http://xf.iksaif.net
