Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab2DQQGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:06:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60398 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2DQQGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:06:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120417141023.40aefc2ff17c29b2edf51762@canb.auug.org.au>
References: <20120417141023.40aefc2ff17c29b2edf51762@canb.auug.org.au>
Date: Tue, 17 Apr 2012 11:06:48 -0500
Message-ID: <CABqD9hbi=2SsybyirtCPivUerrx6Uohu5GJLc_gaUcTiT8h-kg@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the final tree (security
 tree related)
From: Will Drewry <wad@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Eric Paris <eparis@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doh - thanks! I'll figure out the right way to silence these warnings
in this config case and post the patch against James's tree.

Thanks!

On Mon, Apr 16, 2012 at 11:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> produced this warning:
>
> kernel/seccomp.c: In function '__secure_computing':
> kernel/seccomp.c:445:1: warning: label 'skip' defined but not used [-Wunused-label]
> kernel/seccomp.c:381:6: warning: unused variable 'data' [-Wunused-variable]
> kernel/seccomp.c:380:6: warning: unused variable 'ret' [-Wunused-variable]
>
> Introduced by commit acf3b2c71ed2 ("seccomp: add SECCOMP_RET_ERRNO").
> This build has CONFIG_SECCOMP_FILTER turned off.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
