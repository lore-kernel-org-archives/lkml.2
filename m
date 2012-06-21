Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2FUHyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:54:41 -0400
Received: from mail.renton.name ([90.155.165.44]:36703 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2FUHyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:54:40 -0400
Date: Thu, 21 Jun 2012 11:54:28 +0400
From: Alexey Vlasov <renton@renton.name>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Attaching a process to cgroups
Message-ID: <20120621075428.GE31797@beaver>
References: <20120619185856.GC31797@beaver>
 <1340195298.15707.3.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1340195298.15707.3.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 02:28:18PM +0200, Mike Galbraith wrote:
> 
> kernel/cgroup.c::cgroup_attach_task()
> {
> ...
> 	synchronize_rcu();
> ...
> }

So nothing can be done here? (I mean if only I knew how to fix it I
wouldn't ask about it ;)
