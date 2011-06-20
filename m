Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1FTXUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:20:01 -0400
Received: from tundra.namei.org ([65.99.196.166]:57952 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab1FTXT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:19:59 -0400
Date: Tue, 21 Jun 2011 09:19:34 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Vasiliy Kulikov <segoon@openwall.com>
cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
In-Reply-To: <20110620170600.GA25601@albatros>
Message-ID: <alpine.LRH.2.00.1106210918290.14297@tundra.namei.org>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org> <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org> <20110620103917.GA5230@albatros> <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org> <20110620170600.GA25601@albatros>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Vasiliy Kulikov wrote:

> > If they depend on specific permissions, yes.
> 
> Could you please then clarify why does this patch changes
> pid_revalidate() behaviour:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=99f895518368252ba862cc15ce4eb98ebbe1bec6
> 
> It changes files permissions to allow userspace apps to quickly stat
> files, not looking into /proc/PID/status.  So, uid and gid are explicit
> ABI.  Breaking procfs uid/gid attributes would break these apps.
> 

Right, but I'm saying that apps which depend on specific permissions are 
broken, which is not the uid / gid attributes.


-- 
James Morris
<jmorris@namei.org>
