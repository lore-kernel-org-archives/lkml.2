Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2JHX6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:58:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37901 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2JHX6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:58:35 -0400
MIME-Version: 1.0
In-Reply-To: <1349716293-16723-1-git-send-email-bp@amd64.org>
References: <1349716293-16723-1-git-send-email-bp@amd64.org>
Date: Mon, 8 Oct 2012 16:58:34 -0700
X-Google-Sender-Auth: 7KJHmHsjTZqJlVFpxiCf-TgTSnc
Message-ID: <CA+8MBbJw8dQEJK-fXFKkDS0_+Ax6ZxppkmxBK+AGafk1YLcvyQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] AMD MCE injection improvs
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
Cc: EDAC devel <linux-edac@vger.kernel.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 10:11 AM, Borislav Petkov <bp@amd64.org> wrote:
>  create mode 100644 arch/x86/ras/ras.c

Overall it looks good - but I'm a bit puzzled by this ras.c file that gets
created as an empty file in part1, and is still empty at the end of the
series.

What is going to go into it?

-Tony
