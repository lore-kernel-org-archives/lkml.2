Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab2J0Tfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932674Ab2J0Tfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:35:54 -0400
Date: Sat, 27 Oct 2012 21:35:44 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 27/33] tools, perf: Add a precise event qualifier
Message-ID: <20121027193544.GC1039@krava.redhat.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
 <1351283415-13170-28-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351283415-13170-28-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:30:09PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a precise qualifier, like cpu/event=0x3c,precise=1/
hm, I think this works already via 'p' modifier like:
   cpu/event=0x3c/p

jirka
