Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab2FHKmC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:42:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41454 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2FHKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:41:59 -0400
Date: Fri, 8 Jun 2012 03:41:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Minchan Kim <minchan@kernel.org>
Subject: Re: [ 31/82] mm/vmalloc.c: change void* into explict vm_struct*
In-Reply-To: <20120608041845.013957176@decadent.org.uk>
Message-ID: <alpine.DEB.2.00.1206080341050.4994@chino.kir.corp.google.com>
References: <20120608041845.013957176@decadent.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2012, Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Minchan Kim <minchan@kernel.org>
> 
> commit db1aecafef58b5dda39c4228debe2c845e4a27ab upstream.
> 
> vmap_area->private is void* but we don't use the field for various purpose
> but use only for vm_struct.  So change it to a vm_struct* with naming to
> improve for readability and type checking.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

I'm not sure this is stable material and it wasn't annotated as such when 
it was commited, why should someone need to upgrade their 3.2 for a patch 
like this?
