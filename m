Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab1IFU16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:27:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab1IFU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:27:52 -0400
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1109062146150.2723@ionos>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
	 <1314661157-22173-4-git-send-email-andi@firstfloor.org>
	 <alpine.LFD.2.02.1109021135270.2723@ionos>
	 <20110904165658.GA23948@redhat.com> <20110904202907.GA3404@redhat.com>
	 <20110906031411.GA24024@alboin.amr.corp.intel.com>
	 <20110906145124.GA15390@redhat.com>
	 <1315323596.2899.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <alpine.LFD.2.02.1109061823100.2723@ionos>
	 <20110906184926.GA25997@redhat.com>
	 <alpine.LFD.2.02.1109062110090.2723@ionos>
	 <1315337411.3400.12.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1109062146150.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 22:27:40 +0200
Message-ID: <1315340860.3400.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 septembre 2011 à 22:10 +0200, Thomas Gleixner a écrit :

> Vs. the refcounting, that should be solvable by a rcu_barrier() before
> 
> +   idr_destroy(&sig->posix_timers_id);
> 
> in exit_itimers().

Well, rcu_barrier() is too slow, please Andi dont try this :)



