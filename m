Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0FCXC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:02:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842Ab0FCXCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:02:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: unify save_stack_address() and
	save_stack_address_nosched()
In-Reply-To: Oleg Nesterov's message of  Thursday, 3 June 2010 21:32:43 +0200 <20100603193243.GA31534@redhat.com>
References: <20100603193243.GA31534@redhat.com>
Emacs: a real time environment for simulating molasses-based life forms.
Message-Id: <20100603230125.61B9A4A549@magilla.sf.frob.com>
Date: Thu,  3 Jun 2010 16:01:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
