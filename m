Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2BUQ6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 11:58:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33096 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2BUQ6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 11:58:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.132.229 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Tue, 21 Feb 2012 08:58:41 -0800
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix generic definition of
 __this_cpu_add_and_return()
Message-ID: <20120221165841.GA12236@google.com>
References: <20120219142911.12300.7497.stgit@zurg>
 <alpine.DEB.2.00.1202210952510.10145@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202210952510.10145@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 09:53:08AM -0600, Christoph Lameter wrote:
> On Sun, 19 Feb 2012, Konstantin Khlebnikov wrote:
> 
> > This patch adds missed "__" into function prefix.
> > Otherwise on all archectures (except x86) it expands to irq/preemtion-safe
> > variant: _this_cpu_generic_add_return(), which do extra irq-save/irq-restore.
> > Optimal generic implementation is __this_cpu_generic_add_return().
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Applied to 3.3-fixes.  Thanks.

-- 
tejun
