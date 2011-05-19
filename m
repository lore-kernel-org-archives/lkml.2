Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1ESLsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:48:42 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48627 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755109Ab1ESLsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:48:41 -0400
Date: Thu, 19 May 2011 12:48:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: pfn_valid() is broken on low memory HIGHMEM
 systems
Message-ID: <20110519114841.GA17284@linux-mips.org>
References: <1b31306f28573a4bee56f164b1f74962fced9bc5@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b31306f28573a4bee56f164b1f74962fced9bc5@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queued for 2.6.41 with David Daney's suggested change to avoid GNU C
extensions but I'm probably going to change my mind and will push this
earlier.

Thanks!

  Ralf
