Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab1GMVGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:06:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:59539 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1GMVGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:06:13 -0400
Subject: Re: [PATCHv2] perf tools: Add missing 'node' alias to the hw_cache
 array
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20110713205818.GB7827@jolsa.brq.redhat.com>
References: <1310483256-5772-1-git-send-email-jolsa@redhat.com>
	 <1310484647.14978.33.camel@twins>
	 <20110713204348.GA7827@jolsa.brq.redhat.com>
	 <20110713205818.GB7827@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 23:06:08 +0200
Message-ID: <1310591168.2586.39.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 22:58 +0200, Jiri Olsa wrote:
> Adding "node" as a simple alias for NODE cache events.
> 
> The addition of NODE cache events broke the parse_alias function,
> so any mismatched event caused the segfault, like:
> 
>   # ./perf stat -e krava ls
> 
> The hw_cache/hw_cache_op/hw_cache_result arrays needs to follow
> PERF_COUNT_HW_CACHE_*MAX enums. Adding those MAXs to be size
> of those arrays, so possible ommision in future wil not lead to
> segfault.
> 
> Adding read/write/prefetch as allowed operations for node cache
> event.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com> 

Thanks!
