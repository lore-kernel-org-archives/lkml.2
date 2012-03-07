Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030431Ab2CGV3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:29:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030363Ab2CGV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:28:58 -0500
Subject: Re: [PATCH 08/29] Disintegrate asm/system.h for C6X
From: Mark Salter <msalter@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, mingo@redhat.com, arnd@arndb.de,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 16:28:45 -0500
In-Reply-To: <20120307194725.15987.99209.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
	 <20120307194725.15987.99209.stgit@warthog.procyon.org.uk>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331155726.12805.16.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 19:47 +0000, David Howells wrote:
> Disintegrate asm/system.h for C6X.  Not compiled.  Appears to be missing
> asm/atomic.h and asm/bug.h.

Not missing. C6X uses the asm-generic versions which makes me think that
at least the atomic.h and barrier.h bits could have reasonable generic
versions for UP-only systems.

--Mark


