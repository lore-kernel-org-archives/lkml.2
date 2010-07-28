Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0G1Nof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:44:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0G1NoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:44:25 -0400
From: Andreas Schwab <schwab@redhat.com>
To: michalj@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make sure abs() always works on a signed argument
References: <20100728123048.GA4127@quadria>
X-Yow: Mmmmmm-MMMMMM!!  A plate of STEAMING PIECES of a PIG mixed
 with the shreds of SEVERAL CHICKENS!!...  Oh BOY!!  I'm
 about to swallow a TORN-OFF section of a COW'S LEFT LEG
 soaked in COTTONSEED OIL and SUGAR!!  ..  Let's see..
 Next, I'll have the GROUND-UP flesh of CUTE, BABY LAMBS
 fried in the MELTED, FATTY TISSUES from a warm-blooded
 animal someone once PETTED!!  ...  YUM!!  That was GOOD!!
 For DESSERT, I'll have a TOFU BURGER with BEAN SPROUTS
 on a stone-ground, WHOLE WHEAT BUN!!
Date: Wed, 28 Jul 2010 15:44:22 +0200
In-Reply-To: <20100728123048.GA4127@quadria> (Michal Januszewski's message of
	"Wed, 28 Jul 2010 14:44:25 +0200")
Message-ID: <m3eienu3ex.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Januszewski <michalj@gmail.com> writes:

> To fix this problem, explicitly cast the argument of abs() to signed, so
> that it gets properly expanded to long in case the original argument was
> an int.

This will of course re-introduce the truncation, and effectively reverts
a49c59c0.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
