Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0KIEYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 23:24:07 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37650 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0KIEYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 23:24:04 -0500
Date: Tue, 9 Nov 2010 00:48:09 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/14] arch/mips/pmc-sierra/yosemite/setup.c: delete
 double assignment
Message-ID: <20101109004808.GA10116@linux-mips.org>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-7-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288088743-3725-7-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 12:25:35PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Delete successive assignments to the same location.

[...]

> This change also makes the variable cpu_clock_freq be not used in the
> current file.  If this is the correct change to plat_time_init, then
> perhaps the declaration of that variable should be moved elsewhere, or the
> variable should be deleted completely.

The 2nd assignment is a temporary override for debugging purpose that is
it's there intionsionally.

Thanks!

  Ralf
