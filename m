Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2KDKNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:13:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35984 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2KDKNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:13:49 -0500
Date: Sun, 4 Nov 2012 10:13:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>, Jon Medhurst <tixy@yxit.co.uk>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com
Subject: Re: [PATCH 8/9] ARM: support uprobe handling
Message-ID: <20121104101327.GZ21164@n2100.arm.linux.org.uk>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-8-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350242593-17761-8-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 09:23:12PM +0200, Rabin Vincent wrote:
> Extend the kprobes code to handle user-space probes.  Much of the code
> can be reused so currently the ARM uprobes code reuses the kprobes
> structures.  The decode tables are reused, with the modification that
> for those instruction that require custom decoding for uprobes, a new
> element is added in the table to specify a custom decoder function.

How are accesses to userspace handled by the kprobes code?  Please point
me to where these accesses are performed.
