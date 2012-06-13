Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2FMV7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:59:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:40683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2FMV7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:59:03 -0400
Message-ID: <1339624738.8980.77.camel@twins>
Subject: Re: [PATCH 2/2] perf, x86: Enable PDIR precise instruction
 profiling on IvyBridge
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 23:58:58 +0200
In-Reply-To: <20120613215424.GG32604@tassilo.jf.intel.com>
References: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
	 <1339615201-7456-2-git-send-email-andi@firstfloor.org>
	 <1339622781.8980.63.camel@twins>
	 <20120613213651.GD32604@tassilo.jf.intel.com>
	 <1339623838.8980.71.camel@twins>
	 <20120613215424.GG32604@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 14:54 -0700, Andi Kleen wrote:
> Yes it's in effect, and it forces the event to counter 1. 
> That is correct and that restriction is still there. 

OK, when we cannot magically replace 'instructions' with pdir.
