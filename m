Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0H2S4f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:56:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46688 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0H2S4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=REJ80SyMul8wc80A60N+/p98Rctw1A/MIRWHARpY+nu8Wxav8f0jWnnFuD2CBpRFY0
         U5XoUb4WY20PxPw1V6pt7FspPDJ5Nogm6CVrlpEYaAPJPcOJD7evgEdag4M99cVZbsNJ
         FTyNYM9E4kh8E+4eSF3Yo29kmj5vw6BY1254k=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-10-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-10-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:54:49 +0300
X-Google-Sender-Auth: I6AvcTPVd-GFIPX6cIfsCPZqOzI
Message-ID: <AANLkTinpzZTh+eYt90BKnAK5K6MbE5bpsNqAnH5Xg0Pd@mail.gmail.com>
Subject: Re: [PATCH 09/11] x86: Merge fpu_save_init()
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Merge 32-bit and 64-bit fpu_save_init().
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

This patch is pretty hard to review. Maybe you could split this into
two patches where the first preparational patch would introduce some
helpers such as fpu_fxsave() on 32-bit. It should be easier to review
the fpu_save_init() merging in a second patch that way.
