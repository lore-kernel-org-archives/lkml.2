Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab1FAXCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:02:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63764 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1FAXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nq7Vz7l7HsmTzoX1Umfit8/aqPA9CPHacNtyhGrp2iGfRu04zzSMe+VHWppalepqKL
         zx8duzFaSm+XyTBoh1CA0FG0Tacr/cPkpI/PI0Un5UubT2L+8XRp1l8fVYVFMXz268A4
         UHTv0msDPVdK7drqff9WeKFDUacYA9DnI7FeI=
Message-ID: <4DE6C4EE.8020807@gmail.com>
Date: Thu, 02 Jun 2011 01:02:06 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH 2/2] xhci: Do not issue device reset when device
 is not setup
References: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com> <1306963670-6344-2-git-send-email-m.b.lankhorst@gmail.com> <20110601221722.GB17429@kroah.com> <20110601224205.GC13079@xanatos>
In-Reply-To: <20110601224205.GC13079@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

Op 02-06-11 00:42, Sarah Sharp schreef:
> Maarten, if you feel a patch needs to be added to the stable trees,
> please just add this line below your Signed-off-by line:
>
> Cc: stable@kernel.org
>
> Don't Cc stable in your initial RFC patches.  Once they're done, I'll
> queue them to my xHCI tree and send them off to Greg.  When Greg sends
> them off to Linus for inclusion into 3.0, the patches will automatically
> get picked up into the stable tree.
Sorry about that. I interpreted cc'ing stable wrongly, feel like such a
noob on this whole submitting patches thing. :)

I do think it needs inclusion in stable though, since it fixes the
xhci controller that so far never worked for me, although the earliest
kernel I tested on was v2.6.33.$x-rt$y. Didn't test the patch though,
but iirc the failure mode wasn't any different.

~Maarten
