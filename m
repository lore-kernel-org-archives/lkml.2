Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2DWPXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:23:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45346 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2DWPXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:23:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120423165630.b412159ec0e5412ba41e0a98@canb.auug.org.au>
References: <20120423165630.b412159ec0e5412ba41e0a98@canb.auug.org.au>
Date: Mon, 23 Apr 2012 08:23:48 -0700
X-Google-Sender-Auth: gfi-uW12toMfxYLbgBzHsb2lxTU
Message-ID: <CAGXu5j+KuoXLyjYZ2G9vS2XmHUKQ6diNGcV4XnEY+fOpS1DyQQ@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the security tree
From: Kees Cook <keescook@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 11:56 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the security tree, today's linux-next build (powerpc
> allyesconfig) produced this warning:
>
> security/yama/yama_lsm.c:322:12: warning: 'one' defined but not used [-Wunused-variable]
>
> Introduced by commit 389da25f93ee ("Yama: add additional ptrace scopes").

Thanks! This has already been taken care of:

http://marc.info/?l=linux-security-module&m=133516581114617&w=2

-Kees

-- 
Kees Cook
Chrome OS Security
