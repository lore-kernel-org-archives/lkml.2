Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab1LOCmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:42:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64986 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1LOCmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:42:08 -0500
Date: Wed, 14 Dec 2011 18:42:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wang Sheng-Hui <shhuiw@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy.c: use enum value MPOL_REBIND_ONCE instead
 of 0 in mpol_rebind_policy
In-Reply-To: <4EE8A461.2080406@gmail.com>
Message-ID: <alpine.DEB.2.00.1112141840550.27595@chino.kir.corp.google.com>
References: <4EE8A461.2080406@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011, Wang Sheng-Hui wrote:

> We have enum definition in mempolicy.h: MPOL_REBIND_ONCE.
> It should replace the magic number 0 for step comparison in
> function mpol_rebind_policy.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>

Tip: when proposing patches, it's helpful to run scripts/get_maintainer.pl 
on your patch file from git to determine who should be cc'd on the email.
