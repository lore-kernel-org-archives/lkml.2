Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab2F1Jac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:30:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab2F1Jab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:30:31 -0400
Message-ID: <4FEC242F.7050906@suse.cz>
Date: Thu, 28 Jun 2012 11:30:23 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kbuild@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Remove useless wrappers of asm-generic/cpumask.h
References: <1340306406.1773.59.camel@x61.thuisdomein>
In-Reply-To: <1340306406.1773.59.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.6.2012 21:20, Paul Bolle wrote:
> frv and xtensa both have a header (in their include/asm directories)
> that are thin wrappers around asm-generic/cpumask.h. These wrappers are
> useless, since that header doesn't exist. They are also unused (all
> files including asm/cpumask.h are x86 specific).
> 
> hexagon and openrisc generate similar headers at build time (using a
> generic-y entry in include/asm/Kbuild). These generated headers are
> useless and unused too.
> 
> Remove these headers and generic-y entries.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, applied to kbuild.git#trivial.

Michal
