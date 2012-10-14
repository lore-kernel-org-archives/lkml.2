Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab2JNK5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:57:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab2JNK5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:57:03 -0400
MIME-Version: 1.0
In-Reply-To: <20121013022955.610890388@goodmis.org>
References: <20121013022632.024527228@goodmis.org>
	<20121013022955.610890388@goodmis.org>
Date: Sun, 14 Oct 2012 12:57:02 +0200
Message-ID: <CAFLxGvxXgbCzGjKVLpsgqo+jicTfevK6tAq0Bjongi1eSRok5w@mail.gmail.com>
Subject: Re: [PATCH 22/25] um: Use Kbuild infrastructure for kvm_para.h
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 4:26 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> All the headers but kvm_para.h use the Kbuild infrastructure to
> get to the asm-generic headers.
>
> (also had to add ipcbuf.h)
>
> Cc: linux-kbuild@vger.kernel.org
> Cc: user-mode-linux-devel@lists.sourceforge.net
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Richard Weinberger <richard@nod.at>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Richard Weinberger <richard@nod.at>

-- 
Thanks,
//richard
