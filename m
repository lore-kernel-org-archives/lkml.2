Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1I0XRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:17:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59197 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1I0XRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
References: <CA+55aFwdm3n+xehYc1cronkcwLE79ZYtr96LiVWD2WjKkaZ5DA@mail.gmail.com>
 <CACqU3MXzUbQS9fy0Etgt2GcgwRoXfihhmw-aWjrCFbzvmDM7yg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Sep 2011 16:17:25 -0700
X-Google-Sender-Auth: APFKZGXL2GpJfQzG5aiKpVQBOCc
Message-ID: <CA+55aFwKyd5fuyxu2tGDbQ8gKiEj=z7uYdBRg9O46WN0sTeNTQ@mail.gmail.com>
Subject: Re: Linux 3.1-rc7
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 4:13 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>
> this -rc fails to build on my config (attached):
>
> arch/x86/kernel/i387.c: In function 'restore_i387_xsave':
> arch/x86/kernel/i387.c:726:1: warning: "/*" within comment

Hmm. That seems completely bogus.

Are you sure you have a clean kernel tree? Because I suspect that file
is corrupted on your machine.

                       Linus
