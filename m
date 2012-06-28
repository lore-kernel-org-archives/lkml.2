Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab2F1Jb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:31:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab2F1Jb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:31:28 -0400
Message-ID: <4FEC246B.7070800@suse.cz>
Date: Thu, 28 Jun 2012 11:31:23 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kbuild@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net, Chris Zankel <chris@zankel.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Remove useless wrappers of asm-generic/rmap.h
References: <1340306497.1773.61.camel@x61.thuisdomein>
In-Reply-To: <1340306497.1773.61.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.6.2012 21:21, Paul Bolle wrote:
> xtensa has a header (in its include/asm directory) that is a thin
> wrapper around asm-generic/rmap.h. This wrapper is useless, since that
> header doesn't exist. It is also unused (no file includes asm/rmap.h).
> 
> openrisc generates a similar header at build time (using a generic-y
> entry in include/asm/Kbuild). This generated header is useless and
> unused too.
> 
> Remove this header and this generic-y entry.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to kbuild.git#trivial.

Michal
