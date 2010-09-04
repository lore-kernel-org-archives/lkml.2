Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab0IDHlI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 03:41:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39004 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab0IDHlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 03:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=pQPW/UCMLuqF0nOFYSIQurcMII5BtKVz4zG6ZKwRBC6uOTWh6hAycyRMZU/r+b+Fmf
         3rMGwRxB7idd0l/0dQYOPPfvStytkHnKCEGhAmIFQzZqd0aZo36ZZ8r/BmxiAiGgCSTS
         V/xFVrqwxKHYyV+XFp7ZOG/8vnXxAaJ+4jPjo=
MIME-Version: 1.0
In-Reply-To: <1283552891-13966-2-git-send-email-mark.brown314@gmail.com>
References: <1283552891-13966-1-git-send-email-mark.brown314@gmail.com> <1283552891-13966-2-git-send-email-mark.brown314@gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 4 Sep 2010 15:40:44 +0800
Message-ID: <AANLkTim_Z=ppernEbttKz6hcaT=F+DZDBTkhQMSipACK@mail.gmail.com>
Subject: Re: [PATCH v2 1/6 RESEND] ARM: pxa27x/pxa3xx: moved pxa27x_keypad.h
 to platform pxa directory
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 4, 2010 at 6:28 AM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> mach-mmp utilizes pxa27x_keypad code so we need to move header to
> platform pxa directory.
>
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>

Applied to 'devel'.
