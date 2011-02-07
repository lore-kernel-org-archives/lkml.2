Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1BGXfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:35:21 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51505 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1BGXfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hN+7i0Q6yXSlpvD/A6fB/W8WpCeKz8h1Hx6f/M4YnmfpIUKaZHT1uZPzlv82pngGRr
         15G9G0c8u16SsBvJaJzCl8Uox6dkEIH4rR6P0KcedHXrzcEObjO5Is+aetdXsIPUcNct
         UMWdCun32fXoaaQVWZh+cgUmEDAgWwE5rSA70=
MIME-Version: 1.0
In-Reply-To: <20110205193740.964969119@linutronix.de>
References: <20110205193740.964969119@linutronix.de>
Date: Mon, 7 Feb 2011 15:35:17 -0800
X-Google-Sender-Auth: SGDQbCwj-f3n0mzlp9KqpZC6EYA
Message-ID: <AANLkTimd37W_PBtQhhHf3YHj_ms6d-g7F6EQVACNigc+@mail.gmail.com>
Subject: Re: [patch 0/8] ia64: Convert irq_chips to new functions
From: Tony Luck <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jes Sorensen <jes@sgi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 5, 2011 at 11:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> The following series converts the interrupt chips to the new
> functions.Compile tested only.

I see a new warning while building:

arch/ia64/sn/kernel/irq.c:427: warning: ‘force_interrupt’ defined but not used

since you deleted the only use of this function.
sn_force_interrupt_flag doesn't
seem to be useful either once this patch has been applied.

Apart from that it all seems to build and boot with no problems on my
machine.  I haven't tested on SGI sn2 system (where you've made
a moderately big change).  It'd be nice to get an Ack from there.

-Tony
