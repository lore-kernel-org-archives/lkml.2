Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab2FDO5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:57:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46375 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2FDO5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:57:38 -0400
Message-ID: <1338821840.28282.56.camel@twins>
Subject: Re: [PATCH 0/3] uprobes: make register/unregister O(n)
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 16:57:20 +0200
In-Reply-To: <20120604145238.GA6408@redhat.com>
References: <20120604145238.GA6408@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 16:52 +0200, Oleg Nesterov wrote:
> Peter, I forgot about your patch initially, so I am re-sending it
> as 3/3 on top of 1-2. Hopefully you do not mind but I can rebase
> 1-2 on top of your change. 

Nah, I don't mind. Your change to register_for_each_vma() looks good
too.

Thanks!
