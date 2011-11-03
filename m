Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1KCV4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:56:12 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:35900 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab1KCV4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:56:11 -0400
Subject: Re: [GIT PULL] UML changes for 3.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
In-Reply-To: <4EB30994.9050309@nod.at>
References: <4EB14F51.1050004@nod.at>
	 <1320348750.14409.249.camel@x61.thuisdomein>
	 <1320352899.14409.260.camel@x61.thuisdomein>
	 <1320354072.14409.265.camel@x61.thuisdomein>  <4EB3045A.6050501@nod.at>
	 <1320355503.14409.269.camel@x61.thuisdomein>  <4EB30994.9050309@nod.at>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 22:56:09 +0100
Message-ID: <1320357369.14409.276.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 22:37 +0100, Richard Weinberger wrote:
> Your patch looks fine with one exception, setting SUBARCH to the empty
> string could be problematic in the future.

These Makefiles always make me nervous. Is SUBARCH set by the time the
update-po-config target is run? If so, we could simply do "env SUBARCH=
$(SUBARCH) [...]". But how do I check that SUBARCH really is set (ie,
that I'm not passing env an empty string)?


Paul Bolle

