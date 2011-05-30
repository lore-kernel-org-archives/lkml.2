Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab1E3OnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:43:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33669 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab1E3OnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KYadVhQYT+frsvO8gJjCM8iRp0trBRAYk3dD4bNEGBwOtZcvC3qVGAFdiQbGd56vca
         D9i7JELxhXr3byKX3TDHLGQKtCwsuNiuHvDL/Q57RvoKo/mCBjkYKER+DOqp/Os0EOD9
         cxGs4yB9DjewjN0L9xefwycazi+MwQgGpONqE=
MIME-Version: 1.0
In-Reply-To: <1306763923-11892-1-git-send-email-mmarek@suse.cz>
References: <1306763923-11892-1-git-send-email-mmarek@suse.cz>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 30 May 2011 16:43:01 +0200
Message-ID: <BANLkTinU9DoY4gUXK2kaoUiNvbG905-ngQ@mail.gmail.com>
Subject: Re: [PATCH] depmod: Handle X.Y kernel versions
To: Michal Marek <mmarek@suse.cz>
Cc: Jon Masters <jcm@redhat.com>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 15:58, Michal Marek <mmarek@suse.cz> wrote:
> What a stupid check.

> Jon, could you please apply this patch and release a new
> module-init-tools?  Depmod otherwise fails when building a kernel with
> version 3.0 (without the third number).
>
> Linus, I'm affraid this ruins the plan for Linux 3.0. Except if you want
> to force users to upgrade module-init-tools, with the excuse that 3.0
> is a huge step forward and breakage has to be expected ;-).

Maybe get rid of the entire check? We could remove the (not too
useful) 'epoch' some day and just increase the major number with every
release and leave Greg both remaining digits :)

Kay
