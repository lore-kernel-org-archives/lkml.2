Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab2CINCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:02:40 -0500
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:55238 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab2CINCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:02:38 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 08:02:38 EST
Date: Fri, 9 Mar 2012 13:56:55 +0100
From: Jesper Nilsson <jesper@jni.nu>
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, mingo@redhat.com, arnd@arndb.de,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 09/29] Disintegrate asm/system.h for CRIS
Message-ID: <20120309125654.GA1833@jni.nu>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
 <20120307194735.15987.39717.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307194735.15987.39717.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.249.222.9
X-Scan-Result: No virus found in message 1S5zOH-0005le-HZ.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1S5zOH-0005le-HZ e715b8dea00e0fe5f783ed6f4c91b923
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 07:47:35PM +0000, David Howells wrote:
> Disintegrate asm/system.h for CRIS.

Looks good,

> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

/^JN - Jesper Nilsson
--
                  Jesper Nilsson -- jesper_at_jni.nu
