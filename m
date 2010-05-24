Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0EXG7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:59:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:32988 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab0EXG7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:59:15 -0400
Date: Mon, 24 May 2010 08:59:09 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacek J <69rydzyk69@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CPU #1 not responding Problem
Message-ID: <20100524065909.GA21310@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacek J <69rydzyk69@gmail.com>, linux-kernel@vger.kernel.org
References: <AANLkTinHkcWaHs8Hf6zvRjftC5hPkpHbC2LTaz-h4TJ3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTinHkcWaHs8Hf6zvRjftC5hPkpHbC2LTaz-h4TJ3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacek J <69rydzyk69@gmail.com>
Date: Mon, May 24, 2010 at 12:14:49AM +0200

Hi,

> sometimes (very rarely), when I boot my machine, I get messages that
> some cores are not responding (#0, #,1 #,2). #3 is responding and
> system boots with one core. After reboot it boots fine with all 4
> cores. My CPU is Phenom II X940, I use archlinux.

what kernel are you using? Can we see the dmesg of the time when the
cores are not responding? Can you try reproducing this with a vanilla
kernel from kernel.org.

Thanks.

-- 
Regards/Gruss,
    Boris.
