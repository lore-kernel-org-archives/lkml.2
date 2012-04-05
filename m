Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2DEGJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:09:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41959 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2DEGJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:09:41 -0400
Date: Wed, 4 Apr 2012 23:09:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vichy <vichy.kuo@gmail.com>
cc: Kautuk Consul <consul.kautuk@gmail.com>,
        Kernel Newbies <kernelnewbies@nl.linux.org>,
        linux-kernel@vger.kernel.org
Subject: Re: some questions about __get_vm_area_node
In-Reply-To: <CAOVJa8EVHhfFfHHNAyAeT0ZYj3vZFW3Uu4K2PzBEGGOz92fhiw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1204042308470.7534@chino.kir.corp.google.com>
References: <CAOVJa8EVHhfFfHHNAyAeT0ZYj3vZFW3Uu4K2PzBEGGOz92fhiw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, vichy wrote:

> Hi all:
> I have a question about __get_vm_area_node.
> Q. Why we announce "static struct vmap_area *va;" instead of "struct
> vmap_area *va;"
> I cannot see is there any benefit to take this variable as static.
> 

You're right, there's no need for it to be static.  However, you're 
looking at an old tree.

This was fixed with 0006526d78e9 ("mm/vmalloc.c: remove static declaration 
of va from __get_vm_area_node") in 3.3.
