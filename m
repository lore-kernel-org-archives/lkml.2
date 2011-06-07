Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1FGPkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:40:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51921 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab1FGPkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:40:14 -0400
Subject: Re: [PATCH] perf events: remove 64bit alignment padding from
 perf_event_context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1307460819.1950.5.camel@castor.rsk>
References: <1307460819.1950.5.camel@castor.rsk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 07 Jun 2011 17:39:50 +0200
Message-ID: <1307461190.2322.280.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 16:33 +0100, Richard Kennedy wrote:
> Reorder perf_event_context to remove 8 bytes of 64 bit alignment padding
> shrinking its size to 192 bytes, allowing it to fit into a smaller slab
> and use one fewer cache lines.
> 
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Nice, thanks!
