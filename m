Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1BUUHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 15:07:05 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52437 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1BUUHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 15:07:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bK0jTpl53eq59SSaPxamdc28rCKxewdRjG3vtrQr8e34iq/Is5/BuIvy7uoSHyuoM6
         5SaVz5pwpL/UWSToHp+Hs50NO+YRRdsc9/fT2Y+S1gU/elHkOU1zLeV5/rTkm/OjVtUZ
         8YUxKR//MVJmiyKrpdYYcb/7sdL82ufJpOJ9I=
Message-ID: <4D62C5E1.9070307@pobox.com>
Date: Mon, 21 Feb 2011 15:06:57 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site> <20110208122409.19110.4233.sendpatchset@linux-mhg7.site> <20110208130701.19709cc6@lxorguk.ukuu.org.uk> <AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com> <20110208132518.300bb098@lxorguk.ukuu.org.uk> <4D514754.30203@ru.mvista.com> <AANLkTinE5x=hmQ6Oykw3Tb38HVeL5eHxjdnPOdMt930q@mail.gmail.com>
In-Reply-To: <AANLkTinE5x=hmQ6Oykw3Tb38HVeL5eHxjdnPOdMt930q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2011 04:25 AM, Bartlomiej Zolnierkiewicz wrote:
> Jeff, would it be possible to queue patches #01-15 for 2.6.39 if there
> are no further concerns with them (thus leaving the merging of
> PIIX-like drivers for later)?  They got additional testing on ICH4 and
> they look mostly safe&  straight-forward compared to #16-21.

This seems to directly contradict what you wrote earlier in the thread,

	This is why patches were posted to mailing list with a request
	for a real hardware testing:

	"All testing was done using QEMU's PIIX3 controller emulation
	so any testing with real EFAR, IT8213, old PIIX, RDC and
	Radisys R82600 PATA controllers would be really appreciated.."

	instead of request for a merge.  It was all there in initial
	mail.

and

	I do not really care that much if it will be merged ever

Regardless of this self-contradictory attitude, I do want useful patches 
and many of these patches seem useful.

So I will continue watching the Bart/Alan/Sergei threads play out, and 
then look at merging the result.  In the midst of all the arguing, 
productive work / forward progress is occurring, so the end result 
should be positive.

It would be nice if we could get at least an "it works" test for the 
older hardware, since those are the changes /least/ likely to be tested 
by queueing to linux-next.

	Jeff


