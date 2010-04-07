Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0DGSIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:08:36 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40372 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab0DGSIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:08:35 -0400
X-Greylist: delayed 3796 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 14:08:35 EDT
Date: Wed, 7 Apr 2010 18:04:32 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <julia@diku.dk>
Cc: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/7] arch/mips/kernel: Use set_cpus_allowed_ptr
Message-ID: <20100407170432.GB26242@linux-mips.org>
References: <Pine.LNX.4.64.1003262302480.6480@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003262302480.6480@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 11:03:07PM +0100, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Use set_cpus_allowed_ptr rather than set_cpus_allowed.

Thanks Julia, queued for 2.6.35.

  Ralf
