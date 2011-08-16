Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1HPFl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:41:26 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:33730 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1HPFlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
Date: Tue, 16 Aug 2011 08:41:24 +0300
X-Google-Sender-Auth: qdisnQJiBN2Ju25h5rLVEP2TXyM
Message-ID: <CAOJsxLH5eTh3zT74QsSXHz3WL_qyYeM8M0RTyoozC=suG+MC8Q@mail.gmail.com>
Subject: Re: [PATCH 1/9] Staging: Winbond: Fix case statements in wb35reg.c.
From: Pekka Enberg <penberg@kernel.org>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ilia Mirkin <imirkin@alum.mit.edu>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 3:24 AM, Akshay Joshi <me@akshayjoshi.com> wrote:
> Split the case statement and the code that is executed if the condition
> is met so that it passes checkpatch.pl and conforms to the kernel code
> style.
>
> Signed-off-by: Akshay Joshi <me@akshayjoshi.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
