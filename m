Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0JSWej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:34:39 -0400
Received: from tundra.namei.org ([65.99.196.166]:38158 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0JSWei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:34:38 -0400
Date: Wed, 20 Oct 2010 09:34:11 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.moore@hp.com, kaber@trash.net, sfr@canb.auug.org.au
Subject: Re: [PATCH] secmark: fix config problem when CONFIG_NF_CONNTRACK_SECMARK
 is not set
In-Reply-To: <20101019221732.11590.22215.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.1010200933580.30418@tundra.namei.org>
References: <20101019221732.11590.22215.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Eric Paris wrote:

> When CONFIG_NF_CONNTRACK_SECMARK is not set we accidentally attempt to use
> the secmark fielf of struct nf_conn.  Problem is when that config isn't set
> the field doesn't exist.  whoops.  Wrap the incorrect usage in the config.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
