Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1BIIhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:37:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41234 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1BIIhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 03:37:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CJ94fhwiEAFf1Z1XqbjvZxZhsLfLQMoPoHGDCoukiTMHzCx6ARaw8hC7GDxCeV5uAP
         sScB7/f0F3xSrJ05Z/w+5dflu80eGv+fF1kl27iINg1AtXgWwI7vgzUJzeo3ZeHtN8rg
         LElO+5Vq+WO7DaFEwWr0AcNT/N9zHGNcqLGQ0=
Date: Wed, 9 Feb 2011 09:37:28 +0100
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the workqueues tree
Message-ID: <20110209083728.GD6558@htj.dyndns.org>
References: <20110209151204.efef8089.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209151204.efef8089.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 09, 2011 at 03:12:04PM +1100, Stephen Rothwell wrote:
> After merging the workqueues tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> kernel/built-in.o:(.toc1+0x14c0): undefined reference to `system_freezeable_wq'
> 
> Caused by commit de62c151df9b6568c67977920267392c432f340a ("workqueue:
> add system_freezeable_wq").
> 
> I have used the workqueues tree from next-20110208 for today.

That was embarrassing.  Sorry.  Updated.

-- 
tejun
