Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab2F1Ja6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:30:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758125Ab2F1Ja4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:30:56 -0400
Message-ID: <4FEC2447.40309@suse.cz>
Date: Thu, 28 Jun 2012 11:30:47 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kbuild@vger.kernel.org, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-am33-list@redhat.com, Chris Metcalf <cmetcalf@tilera.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Remove useless wrappers of asm-generic/ipc.h
References: <1340306466.1773.60.camel@x61.thuisdomein>
In-Reply-To: <1340306466.1773.60.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.6.2012 21:21, Paul Bolle wrote:
> mn10300 has a header (in its include/asm directory) that is a thin
> wrapper around asm-generic/ipc.h. This wrapper is useless, since that
> header doesn't exist. It is also unused (no file includes asm/ipc.h).
> 
> hexagon and tile generate similar headers at build time (using a
> generic-y entry in include/asm/Kbuild). These generated headers are
> useless and unused too.
> 
> Remove this header and these generic-y entries.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to kbuild.git#trivial.

Michal
