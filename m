Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab1F3Bxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:53:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35577 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab1F3Bxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <1309381372.27360.4.camel@vitaliy-Vostro-1400>
References: <1309381372.27360.4.camel@vitaliy-Vostro-1400>
Date: Thu, 30 Jun 2011 09:53:48 +0800
Message-ID: <BANLkTi=PwiG8PteN4nqoAsLacfTf8J_0wQ@mail.gmail.com>
Subject: Re: [PATCH] gcov: Disable CONSTRUCTORS for UML
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: vitalivanov@gmail.com
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 5:02 AM, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:
> From df71d030a87910e42045dea517bf955caa72d2a8 Mon Sep 17 00:00:00 2001
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Wed, 29 Jun 2011 23:25:32 +0300
> Subject: [PATCH] gcov: Disable CONSTRUCTORS for UML
>
> Selecting GCOV for UML causing configuration mismatch:
> warning: (GCOV_KERNEL) selects CONSTRUCTORS which has unmet direct dependencies (!UML)
>
> Constructors are not needed for UML.
>
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
