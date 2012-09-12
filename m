Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2ILFGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:06:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab2ILFGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:06:17 -0400
Message-ID: <1347426367.29533.13.camel@cr0>
Subject: Re: [PATCH] fs: prevent double-free on an error path in core dumper
From: Cong Wang <amwang@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>
Date: Wed, 12 Sep 2012 13:06:07 +0800
In-Reply-To: <20120911155950.GA7431@redhat.com>
References: <1347380162-2359-1-git-send-email-vda.linux@googlemail.com>
	 <20120911155950.GA7431@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 17:59 +0200, Oleg Nesterov wrote:
> But, again, the caller does free_note_info(), so why
> elf_note_info_init()
> tries to handle the kmalloc failures? Afaics, we can simplify the code
> and fix the bug.
> 
> What do you think about the patch below? 

Looks reasonable and neat. :)


