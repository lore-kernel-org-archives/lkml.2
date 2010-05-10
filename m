Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab0EJVJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:09:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757183Ab0EJVJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:09:16 -0400
Date: Mon, 10 May 2010 14:08:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] swapper fixes (Was: kernel panic on kill(0,
 SIGTERM) with PGID == 0)
Message-Id: <20100510140820.0e84ecc8.akpm@linux-foundation.org>
In-Reply-To: <20100510194917.GA5249@redhat.com>
References: <4BE01C86.3050908@secunet.com>
	<20100509184510.GA15219@redhat.com>
	<4BE7B3BD.70901@secunet.com>
	<20100510194917.GA5249@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 21:49:17 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Hello,
> 
> Mathias Krause reports that a buggy (or special) /sbin/init can
> crash the kernel if it sends a signal to its pgrp/sid before it
> changes its initial (0,0) pids. See the changelog for 1/4.
> 
> git-bisect blames "start the global /sbin/init with 0,0 special pids"
> commit 430c623121ea88ca80595c99fdc63b7f8a803ae5, but in fact the
> problem was caused by another change, see 2/4.
> 
> The patches do not depend on each other, 3/4 fixes another problem,
> 4/4 is purely cosmetic.
> 

Do you see a need to merge these into 2.6.34?  (I don't)
