Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab2CVGX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 02:23:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:38096 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab2CVGXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 02:23:54 -0400
Message-ID: <1332397358.2982.82.camel@pasglop>
Subject: Re: [PATCH 00/16] mm: prepare for converting vm->vm_flags to 64-bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Date: Thu, 22 Mar 2012 17:22:38 +1100
In-Reply-To: <20120322053958.GA5278@barrios>
References: <20120321065140.13852.52315.stgit@zurg>
	 <20120321100602.GA5522@barrios> <4F69D496.2040509@openvz.org>
	 <20120322053958.GA5278@barrios>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 14:39 +0900, Minchan Kim wrote:
> I think we can also unify VM_MAPPED_COPY(nommu) and VM_SAO(powerpc)
> with one VM_ARCH_1
> Okay. After this series is merged, let's try to remove flags we can
> do. Then, other guys
> might suggest another ideas.

Agreed. I would like more VM_ARCH while at it :-)

Cheers,
Ben.


