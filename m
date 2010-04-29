Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0D3RJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:09:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932619Ab0D3RI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:58 -0400
Date: Thu, 29 Apr 2010 14:53:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-28-16-53 uploaded
Message-Id: <20100429145333.f81c634b.akpm@linux-foundation.org>
In-Reply-To: <18962.1272576730@localhost>
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
	<18962.1272576730@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 17:32:10 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Wed, 28 Apr 2010 16:53:32 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-04-28-16-53 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Dies trying to compile mm/slab.c because something screwed the pooch with
> the definition of numa_mem_id(). My bets are on
> numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch

It Works For Me.  Send .config, please?
