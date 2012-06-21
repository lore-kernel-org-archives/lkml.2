Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2FVAMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:12:32 -0400
Received: from warthog.procyon.org.uk ([90.155.74.18]:53165 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715Ab2FVAMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:12:30 -0400
X-Greylist: delayed 3845 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2012 20:12:29 EDT
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1340306466.1773.60.camel@x61.thuisdomein>
References: <1340306466.1773.60.camel@x61.thuisdomein>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: dhowells@redhat.com, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org, linux-am33-list@redhat.com,
        Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Remove useless wrappers of asm-generic/ipc.h
X-Mailer: MH-E 8.3.1; nmh 1.3; GNU Emacs 24.1.50
Date: Fri, 22 Jun 2012 00:08:51 +0100
Message-ID: <32480.1340320131@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> wrote:

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

Acked-by: David Howells <dhowells@redhat.com> [MN10300]
