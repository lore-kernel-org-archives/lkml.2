Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1A0GjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:39:01 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:42803 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1A0GjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:39:00 -0500
Date: Thu, 27 Jan 2011 07:38:49 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, x86@kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: Re: [patch 0/6] rwsem: Cleanup duplicate code all over the place
Message-ID: <20110127063849.GA2574@osiris.boeblingen.de.ibm.com>
References: <20110126195810.247325792@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126195810.247325792@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:05:44PM -0000, Thomas Gleixner wrote:
> The archictecture specific rwsem implementations have a lot of
> duplicated code. The following series cleans that up.

builds and boots on s390. As far as s390 is concerned:

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
