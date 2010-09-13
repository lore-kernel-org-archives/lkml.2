Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0IMWAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 18:00:03 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:50172 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751805Ab0IMWAC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 18:00:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Yd6eqLwkTi/Q5kKxOO+jt2PDkXDqS5YjcovjNLlkXKrhgBVdiNpM2DOPuRWMFXR/zvmGr4q/JX9JkoPllKfqcCgiHgcoQusRZLvhihZftAljl6Uk1NwpqTAeKHS3z7E+;
Date: Mon, 13 Sep 2010 14:59:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: intel-gfx@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Interrupt latency on some 945GM platforms
Message-ID: <20100913145952.2646a2f8@jbarnes-desktop>
In-Reply-To: <201009140052.36670.anarsoul@gmail.com>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009140041.23645.anarsoul@gmail.com>
	<20100913144632.35420d68@jbarnes-desktop>
	<201009140052.36670.anarsoul@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 00:52:31 +0300
Vasily Khoruzhick <anarsoul@gmail.com> wrote:

> В сообщении от 14 of September 2010 00:46:32 автор Jesse Barnes написал:
> 
> > Yes, you can set vblank_mode=0 in your environment or drirc.  At least
> > I think 0 is no vsync. :)
> 
> That doesn't help, glxgears shows ~1000fps, but it's output is jerky.

Is it smooth with clocksource=tsc?  I wonder if the GPU batch
interrupts are also getting delayed, and possibly timer ticks...

-- 
Jesse Barnes, Intel Open Source Technology Center
