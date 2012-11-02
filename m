Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2KBUNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:13:13 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36758 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2KBUNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <20121102093200.8961C1460DAB@linuxdev-32>
References: <20121102093200.8961C1460DAB@linuxdev-32>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Nov 2012 13:12:48 -0700
X-Google-Sender-Auth: 6szjojwrzXVDLhJFxSZDvXw66js
Message-ID: <CA+55aFzdGqsvkc42n6Qv+dn=fY0qwsXwq7rYi_fCf_jerJk1cg@mail.gmail.com>
Subject: Re: [GIT PULL REQUEST] UniCore32 update for v3.7-rc3
To: guanxuetao <guanxuetao@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 2:32 AM, guanxuetao <guanxuetao@mprc.pku.edu.cn> wrote:
>
>   git://github.com/gxt/linux.git unicore32

Can you please use your gpg signature to make a signed *tag* and ask
me to pull that, instead of signing your email?

Email signing is largely useless, because no email client that I have
ever wanted to use seem to make it useful. In contrast, git signed
tags are checked automatically, and also allow you to write a message
that ends up in the merge automatically..

               Linus
