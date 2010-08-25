Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0HYLmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 07:42:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0HYLmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 07:42:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 2/3 RESEND] ptrace: cleanup address space conversion on ptrace_request()
Date: Wed, 25 Aug 2010 13:42:46 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
References: <201008222206.18523.arnd@arndb.de> <201008241345.06507.arnd@arndb.de> <87sk23w2sn.fsf@gmail.com>
In-Reply-To: <87sk23w2sn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008251342.46107.arnd@arndb.de>
X-Provags-ID: V02:K0:Cs1eJorMGg3qbIy7+JRzfyU57QK+MuMWCqhwp7VnVuJ
 NCZsLENdQyvSV2t0fFus3YC0CeJeB3Vvz4ix6qBZy7D3C/YReA
 inGvvn+CjoukN+E59M1zO/Sf9apJOG/geyYj/oIkICL9vuyuW/
 lP+ssDkB/EMnzWzl3CWmn4LC9qH9HI2m9QpCnKs59qGIN4tuOQ
 wYua0hZ85kBZNmLaVGiVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 August 2010, Namhyung Kim wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> > I don't think we ever rely on 'data' being signed, and user space
> > sees it as 'void *' anyway, so it should be possible to just turn
> > it into 'unsigned long'.
> >
> 
> After I've checked all arch_ptrace() code, I can think there is no specific
> reason @addr and @data to be signed long types. Most of archs use them
> as if they were unsigned. So I'll prepare a patch series to change this
> and some cleanups of ptrace_request() and all of arch_ptrace() if no
> objection exists.

Sounds good to me.

	Arnd
