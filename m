Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2BCUes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:34:48 -0500
Received: from ozlabs.org ([203.10.76.45]:43873 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab2BCUeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:34:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>,
        Tim Abbott <tim.abbott@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] module: Remove module size limit
In-Reply-To: <1327982842-13898-1-git-send-email-sasha.levin@oracle.com>
References: <1327982842-13898-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 03 Feb 2012 14:11:56 +1030
Message-ID: <877h04k2gr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 23:07:22 -0500, Sasha Levin <levinsasha928@gmail.com> wrote:
> Module size was limited to 64MB, this was legacy limitation due to vmalloc()
> which was removed a while ago.
> 
> Limiting module size to 64MB is both pointless and affects real world use
> cases.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Tim Abbott <tim.abbott@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks, applied.

Cheers,
Rusty.
