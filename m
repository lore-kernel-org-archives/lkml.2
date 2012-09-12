Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab2ILDCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:02:45 -0400
Received: from tundra.namei.org ([65.99.196.166]:40915 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2ILDCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:02:44 -0400
Date: Wed, 12 Sep 2012 12:56:19 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples/seccomp: fix 31 bit build on s390
In-Reply-To: <20120908083142.GA4959@osiris.de.ibm.com>
Message-ID: <alpine.LRH.2.02.1209121256050.4482@tundra.namei.org>
References: <20120908083142.GA4959@osiris.de.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Sep 2012, Heiko Carstens wrote:

> >From cea999ef4e68e23c70e64baf054768bdebe15e1b Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Sat, 8 Sep 2012 10:23:42 +0200
> Subject: [PATCH] samples/seccomp: fix 31 bit build on s390
> 
> On s390 the flag to force 31 builds is -m31 instead of -m32 unlike
> on all (?) other architectures.
> 
> Fixes this compile error:
> 
>   HOSTCC  samples/seccomp/bpf-direct.o
> cc1: error: unrecognized command line option "-m32"
> make[2]: *** [samples/seccomp/bpf-direct.o] Error 1
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next
