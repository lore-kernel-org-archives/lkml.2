Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab1ANPsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:48:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076Ab1ANPr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:47:59 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101141028350.2678@localhost6.localdomain6>
References: <alpine.LFD.2.00.1101131436070.2678@localhost6.localdomain6>
 <8952.1294927845@jrobl> <alpine.LFD.2.00.1101131732500.2678@localhost6.localdomain6>
 <AANLkTikjTqcTzBVNouMdb2-QDmEKvH0p_uZ-SE9aNW6f@mail.gmail.com> <alpine.LFD.2.00.1101141028350.2678@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Jan 2011 07:47:09 -0800
Message-ID: <AANLkTinAseKuc3=JxB2qZGz2D4KUyjj=dbnoKfSyVLqh@mail.gmail.com>
Subject: Re: [PATCH] fs: Work around NFS wreckage
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nick Piggin <npiggin@gmail.com>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Nick Piggin <npiggin@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        "Ramirez Luna, Omar" <omar.ramirez@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 1:29 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Can you point us to the patches, so we can run our own set of
> tests in paralell?

They should be in current -git as of yesterday evening.

In particular, I think this one is commit 90dbb77ba48d.

                      Linus
