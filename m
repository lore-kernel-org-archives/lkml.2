Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab1LHHuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:50:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56676 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1LHHuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:50:54 -0500
Date: Wed, 7 Dec 2011 23:50:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kautuk Consul <consul.kautuk@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vmalloc: Remove static declaration of va from
 __get_vm_area_node
In-Reply-To: <1323330621-31254-1-git-send-email-consul.kautuk@gmail.com>
Message-ID: <alpine.DEB.2.00.1112072350380.28419@chino.kir.corp.google.com>
References: <1323330621-31254-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011, Kautuk Consul wrote:

> Static storage is not required for the struct vmap_area in
> __get_vm_area_node.
> 
> Removing "static" to store this variable on the stack instead.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
