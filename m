Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0ELOU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:20:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:56830 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0ELOU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:20:57 -0400
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Peter Zijlstra <peterz@infradead.org>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, balbir@linux.vnet.ibm.com, lennart@poettering.net,
       jsafrane@redhat.com, tglx@linutronix.de
In-Reply-To: <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>
	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 16:20:48 +0200
Message-ID: <1273674048.1626.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 16:13 +0200, Dhaval Giani wrote:
> What you are saying is that an application
> programmer who wants to just use memory cgroups should also care about
> cpusets and just about countless other cgroup subsystems that can
> exist. 

That's exactly what he says if he mounts them together.

