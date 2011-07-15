Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965431Ab1GOKo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 06:44:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:33775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964982Ab1GOKo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:44:27 -0400
Subject: Re: [PATCH] sched: reorder root_domain to remove 64 bit alignment
 padding
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1310726492.1977.5.camel@castor.rsk>
References: <1310726492.1977.5.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 12:44:20 +0200
Message-ID: <1310726660.2586.313.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 11:41 +0100, Richard Kennedy wrote:
> Reorder root_domain to remove 8 bytes of alignment padding on 64 bit
> builds, this shrinks the size from 1736 to 1728 bytes, therefore using
> one fewer cachelines.

depends a bit on how insane struct cpupri is, but yeah, good compaction.
Thanks!
