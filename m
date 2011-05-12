Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1ELFqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 01:46:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45711 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1ELFqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 01:46:36 -0400
Date: Thu, 12 May 2011 07:46:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
Message-ID: <20110512054631.GI6008@one.firstfloor.org>
References: <BANLkTi=XqROAp2MOgwQXEQjdkLMenh_OTQ@mail.gmail.com> <m2fwokj0oz.fsf@firstfloor.org> <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's a nice picture of alt-sysrq-m with lots of memory free but the
> system mostly hung.  I can still switch VTs.

Would rather need backtraces. Try setting up netconsole or crashdump
first.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
