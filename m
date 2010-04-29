Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab0D3S2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:28:53 -0400
Received: from lo.gmane.org ([80.91.229.12]:49046 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933825Ab0D3S1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:27:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Very bad regression from 2.6.33 as of 1600f9def
Date: Thu, 29 Apr 2010 04:36:55 +0000 (UTC)
Message-ID: <loom.20100429T063346-954@post.gmane.org>
References: <loom.20100429T041908-663@post.gmane.org> <4BD8F457.10205@gmail.com> <loom.20100429T045742-593@post.gmane.org> <4BD8F927.2070703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 98.117.134.248 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.3) Gecko/20100409 Firefox/3.6.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock <at> gmail.com> writes:
>
> yep.. luckily 33 is not that far behind
> so it shouldn't take too long.
> As for the CPU patience my friend..
> 
> Justin P. Mattock
> 


On further examination (diff'ing /proc/config.gz and the config that isn't
working) it appears likely that the answer is simply that I am an idiot, having
set the default resume partition to an LVM volume that isn't present at the
beginning of boot. Recompiling and checking now.

