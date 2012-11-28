Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2K1UhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 15:37:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60006 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2K1UhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 15:37:09 -0500
Date: Wed, 28 Nov 2012 21:37:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, eranian@google.com,
        mingo@kernel.org, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 25/32] tools, perf: Add a precise event qualifier
Message-ID: <20121128203708.GS16230@one.firstfloor.org>
References: <1352510868-7911-1-git-send-email-andi@firstfloor.org> <1352510868-7911-26-git-send-email-andi@firstfloor.org> <20121128154038.GE1038@krava.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128154038.GE1038@krava.brq.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should we test for >3?
> 
> 	* precise_ip:
> 	*
> 	*  0 - SAMPLE_IP can have arbitrary skid
> 	*  1 - SAMPLE_IP must have constant skid
> 	*  2 - SAMPLE_IP requested to have 0 skid
> 	*  3 - SAMPLE_IP must have 0 skid
> 
> Maybe it's not implemented in hw yet, but in general it's allowed.

Fixed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
