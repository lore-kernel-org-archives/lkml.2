Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2EHODu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:03:50 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:36858 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754642Ab2EHODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:03:49 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: fMm4dc4VM1nfi6f61aNVsMm6nh4HFaG5mWhsryxeZ53zgPm
 hMdJPrrIw2DmQFyOlbvhOzE.r4kLiuXjKkSwd_EwlsD_VRoYWeGJYfzGW1uM
 9dGWi13.xMetZe.wT5zbwLyDcpf68csqKoRuaP49racP9cYtcYDl3lWP3bA7
 ffAUA081kgZ7PCpzcJFXvF6Xw6rlWjeXACQKJ99HzsZ8hBEOZnJ9ZzhzNTBm
 rnGLfgT9ZYSHHBrHZWKVi0Xw4p_KdsgVhHl690g6a_usbjM2LzvocGlT08y7
 Ih7A5XaXQ9FqCgFnJFYa8wO9_BSRXft8feAx_4lQP0i2LUjGGiy1sklrewBC
 KsVWrn89cLZqFimrljdb1ZsinfvS5ItAZYGRLR6AzuDxght0nhk.sV7Xz2YW
 Zl1pWZYrFurG_8WrHDQxTePALmH.jM7zeBqtx
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 09:03:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        penberg@kernel.org
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
In-Reply-To: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1205080903320.25669@router.home>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Andi Kleen wrote:

> slab_node() could access current->mempolicy from interrupt context.
> However there's a race condition during exit where the mempolicy
> is first freed and then the pointer zeroed.

Acked-by: Christoph Lameter <cl@linux.com>
