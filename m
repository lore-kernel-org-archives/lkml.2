Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0E1PcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 11:32:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373Ab0E1PcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 11:32:03 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/compat_rw_copy_check_uvector: add missing compat_ptr call
References: <20100528114147.GB3686@osiris.boeblingen.de.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 28 May 2010 11:31:29 -0400
In-Reply-To: <20100528114147.GB3686@osiris.boeblingen.de.ibm.com> (Heiko
	Carstens's message of "Fri, 28 May 2010 13:41:47 +0200")
Message-ID: <x49632811ri.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens <heiko.carstens@de.ibm.com> writes:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> A call to access_ok is missing a compat_ptr conversion. Introduced with
> b83733639a494d5f42fa00a2506563fbd2d3015d "compat: factor out
> compat_rw_copy_check_uvector from compat_do_readv_writev"
>
> fs/compat.c: In function 'compat_rw_copy_check_uvector':
> fs/compat.c:629: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast
>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Thanks for catching this.  I'm ashamed I missed the compiler warning.
:(

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
