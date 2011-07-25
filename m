Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab1GYMmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:42:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1GYMmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:42:01 -0400
Subject: Re: [PATCH 0/5] ppc64 scheduler fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110725023311.175792493@samba.org>
References: <20110725023311.175792493@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Jul 2011 14:41:42 +0200
Message-ID: <1311597702.24752.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 12:33 +1000, Anton Blanchard wrote:
> Here are a set of ppc64 scheduler fixes that help with some
> multi node performance issues.

They look fine to me. I'll probably ping you when I'll rip out all that
SD_NODES_PER_DOMAIN crap for good, but until then I'm fine with you
fiddling it for ppc64.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
