Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0EHBSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 21:18:47 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:56475 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab0EHBSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 21:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EYxTNEu15S26m5hAqZ1yLjnNHl+4VkxMOcFB7pApeQX0+uB8zF9cBIHGspXIeManN1
         KZovEJ5LgrDjitegddwx/6usngTjaxkO9X0J52oewegw0DcB9hBvWQz8i5Ah9pRdg+0x
         BfMG47B9YZsVcqGnsLVVmrAnWReO7Xu+48lRg=
MIME-Version: 1.0
In-Reply-To: <20100507105059.GE3479@localhost>
References: <20100507105059.GE3479@localhost>
Date: Fri, 7 May 2010 21:18:44 -0400
X-Google-Sender-Auth: 85d228a4ccdba311
Message-ID: <p2pb6c5339f1005071818u489804e7ud40fe3feb5459bb8@mail.gmail.com>
Subject: Re: ath5k deadlock w/ blob transfer
From: Bob Copeland <me@bobcopeland.com>
To: Nils Radtke <lkml@think-future.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 6:50 AM, Nils Radtke <lkml@think-future.de> wrote:
>  Hi,
>
>  Guess, this is better suited in here:
>>   - ath5k: when starting a blob transfer eg. ssh summer.jpg to the
>>     notebook with the ath5k driver running, the wNIC freezes almost
>>     immediately! Dead device. This is unfortunately too easily reproducible.

> So where should I be posting this?

You're in the right place...

> When both drivers deadlock it's either a common
> base in the wireless driver premisses or yet up the path somewhere in the
> kernel code.

(Or hardware.  madwifi doesn't use mac80211 so it is probably not
common code, but ath5k could have inherited a bug from it.)

> Ideas?

I missed the first email.  What type of machine?  System lockup
or the connection drops?  Do you get any output on the console or
in dmesg? (try switching to a text console before your scp test.)
If not, any output after lockup booting with nmi_watchdog=1?

-- 
Bob Copeland %% www.bobcopeland.com
