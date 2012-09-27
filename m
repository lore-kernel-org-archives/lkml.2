Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab2I0AhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 20:37:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36637 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I0AhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 20:37:02 -0400
Date: Thu, 27 Sep 2012 02:36:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: smp_alt_once && kernel-parameters.txt
Message-ID: <20120927003645.GG16230@one.firstfloor.org>
References: <20120924204948.GA29766@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924204948.GA29766@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> kernel-parameters.txt:
> 
> 	smp-alt-once	[X86-32,SMP] On a hotplug CPU system, only
> 			attempt to substitute SMP alternatives once at boot.
> 
> Who should be fixed?

I would fix the documentation.

Also is it really 32bit only? I doubt it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
