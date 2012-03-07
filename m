Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030730Ab2CGWVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:21:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54317 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030544Ab2CGWVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:21:45 -0500
Date: Wed, 7 Mar 2012 14:21:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: PATCH 1/2] rmap: cleanup anon_vma_prepare
In-Reply-To: <4F575100.30502@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1203071421320.22091@chino.kir.corp.google.com>
References: <4F575045.9010904@linux.vnet.ibm.com> <4F575100.30502@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Xiao Guangrong wrote:

> Sorry for the title typo, repost it.
> 
> -------------------->
> Subject: [PATCH 1/2] rmap: cleanup anon_vma_prepare
> 
> Using the common function anon_vma_chain_link() to link vma and anon_vma
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
