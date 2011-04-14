Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab1DNC2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:28:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758420Ab1DNC2S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <4DA655E7.3000904@zytor.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
	<20110412090207.GE19819@8bytes.org>
	<BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
	<20110412184433.GF19819@8bytes.org>
	<20110413064609.GA18777@elte.hu>
	<20110413172147.GI19819@8bytes.org>
	<4DA5F62F.3030504@kernel.org>
	<20110413193459.GL19819@8bytes.org>
	<4DA60C30.4060606@kernel.org>
	<BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
	<4DA6145D.9070703@kernel.org>
	<BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
	<4DA655E7.3000904@zytor.com>
Date: Wed, 13 Apr 2011 19:27:39 -0700
Message-ID: <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 13, 2011, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yes.  However, even if we *do* revert (and the time is running short on
> not reverting) I would like to understand this particular one, simply
> because I think it may very well be a problem that is manifesting itself
> in other ways on other systems.
>
> The other thing that this has uncovered is that we already have a bunch
> of complete b*llsh*t magic numbers in this
