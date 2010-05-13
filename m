Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab0EMNCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 09:02:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab0EMNC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 09:02:28 -0400
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Peter Zijlstra <peterz@infradead.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, James Kosin <jkosin@intcomgrp.com>,
       linux-kernel@vger.kernel.org, menage@google.com,
       balbir@linux.vnet.ibm.com, jsafrane@redhat.com, tglx@linutronix.de
In-Reply-To: <20100512190757.GA421@tango.0pointer.de>
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>
	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
	 <1273674048.1626.117.camel@laptop> <20100512190757.GA421@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 May 2010 15:01:59 +0200
Message-ID: <1273755719.5605.3537.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 21:07 +0200, Lennart Poettering wrote:
> See Dhaval's patch on the background of systemd
> (http://0pointer.de/blog/projects/systemd.html). When a service is
> started in systemd, we create a cgroup for it, when it ends, we remove
> it. 

I seriously hope that's optional, because I for one would really hate a
system that does that. I still mostly build kernels with only cpuset in
and really don't want anybody but me creating groups in there.


