Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1LVHih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 02:38:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59283 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1LVHif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 02:38:35 -0500
Date: Wed, 21 Dec 2011 23:38:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change void* into explict vm_struct*
In-Reply-To: <1324524793-14049-1-git-send-email-minchan@kernel.org>
Message-ID: <alpine.DEB.2.00.1112212338190.23374@chino.kir.corp.google.com>
References: <1324524793-14049-1-git-send-email-minchan@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011, Minchan Kim wrote:

> Now, vmap_area->private is void* but we don't use the field
> for various purpose but use only for vm_struct.
> So change it with vm_struct* with naming and it's more good
> for readability and type checking.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
