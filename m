Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab0DHB4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 21:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261Ab0DHB4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 21:56:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Fenghua Yu <fenghua.yu@intel.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] posix-cpu-timers: avoid "task->signal != NULL" checks
In-Reply-To: Oleg Nesterov's message of  Thursday, 18 March 2010 19:53:04 +0100 <20100318185304.GA18348@redhat.com>
References: <20100318185304.GA18348@redhat.com>
X-Windows: form follows malfunction.
Message-Id: <20100408015536.F2BD9D258@magilla.sf.frob.com>
Date: Wed,  7 Apr 2010 18:55:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
