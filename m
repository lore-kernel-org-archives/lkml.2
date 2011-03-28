Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1C1PFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:05:03 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37507 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247Ab1C1PFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:05:02 -0400
Date: Mon, 28 Mar 2011 16:04:46 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: __lock_task_sighand() and RCU
Message-ID: <20110328160446.4aeda49c@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110328133602.GA8612@redhat.com>
References: <20110328085654.26a75db6@mfleming-mobl1.ger.corp.intel.com>
	<20110328133602.GA8612@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 15:36:02 +0200
Oleg Nesterov <oleg@redhat.com> wrote:
 
> > But sighands aren't freed via
> > rcu,
> 
> it is ;)
> 
> > it's just a simple refcnt and kmem_cache_free()
> 
> Yes, but please note that sighand_cachep was created with
> SLAB_DESTROY_BY_RCU.

D'oh. I knew it would be something obvious like that.

Thanks Oleg!

-- 
Matt Fleming, Intel Open Source Technology Center
