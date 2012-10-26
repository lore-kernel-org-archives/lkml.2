Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab2JZN30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:29:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758854Ab2JZN3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:29:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [RESEND PATCH 1/4] asm-generic: io: remove {read,write} string functions
Date: Fri, 26 Oct 2012 13:29:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com> <1350488704-3711-2-git-send-email-will.deacon@arm.com>
In-Reply-To: <1350488704-3711-2-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210261329.03386.arnd@arndb.de>
X-Provags-ID: V02:K0:vWCTEK2BqsG6BhqBOWjs/3fvfypIW99QDTDKRTsprCl
 Hh32OtOziGMqSbkdlp/3cqT81UzSv/QuRBaDEj6m46blMoikcZ
 S5YTXsJwoafQp4Es5/przkmgahiETG8BF+f3zOS/0Pd+vCkE31
 Tkizp9FIPx/0j4APuabxX40fl8Z9GxMyh3cAsfgR+y0jMVm8KJ
 a9fe3NuHuQNuKQ3KQYtxcR7OS/jiQQcbSbHXYWgCceVEoNRsmZ
 QBTQv2PzG9kinFiCG5ndunncqWQpug4yfn5ARwBVGvXv+i5HL8
 4UwPz6dWQEgMjsEo4fRf2iOu9TVh4kVoJZBlb88gk53ODShZEu
 PHlUNjFnzJvmThXYJZ+c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2012, Will Deacon wrote:
> The {read,write}s{b,w,l} functions are not defined across all
> architectures and therefore shouldn't be used by portable drivers. We
> should encourage driver writers to use the io{read,write}{8,16,32}_rep
> functions instead.
> 
> This patch removes the {read,write} string functions for the generic IO
> header as they have no place in a new architecture port.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

What should we do with the series? I can take them through the asm-generic
tree if you like, or we can let Catalin take them through the arm64 tree.

	Arnd
