Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2IKRxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:53:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57586 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2IKRxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:53:31 -0400
Date: Tue, 11 Sep 2012 10:53:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SLAB fixes for v3.6-rc5
In-Reply-To: <CAOJsxLHaHhVXeh0bjvQT4_gYgGZAvasEUF_t_KBdAMPHBQuRQQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1209111053060.30962@chino.kir.corp.google.com>
References: <CAOJsxLHaHhVXeh0bjvQT4_gYgGZAvasEUF_t_KBdAMPHBQuRQQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Pekka Enberg wrote:

> Hi Linus,
> 
> Please pull the latest SLAB tree from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent
> 
> It has a PFMALLOC reserve page fixlet for slab from David Rientjes.
> 

Linus merged this patch the same day it was proposed.
