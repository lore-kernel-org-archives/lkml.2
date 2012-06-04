Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229Ab2FDXuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 19:50:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39201 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2FDXuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 19:50:13 -0400
Date: Mon, 4 Jun 2012 16:50:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Salter <msalter@redhat.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: build failure in mm/nommu.c
In-Reply-To: <1338818967.12086.30.camel@deneb.redhat.com>
Message-ID: <alpine.DEB.2.00.1206041649400.7769@chino.kir.corp.google.com>
References: <1338818967.12086.30.camel@deneb.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Mark Salter wrote:

> Commit eb36c587: new helper: vm_mmap_pgoff()
> 
> is causing a build failure:
> 
> .../linux/mm/nommu.c: In function 'sys_mmap_pgoff':
> .../linux/mm/nommu.c:1489:2: error: 'ret' undeclared (first use in this function)
> .../linux/mm/nommu.c:1489:2: note: each undeclared identifier is reported only once for each function it appears in
> 

Try pulling from Linus again, this is fixed by ad1ed2937eaa ("nommu: fix 
compilation of nommu.c") in his tree.
