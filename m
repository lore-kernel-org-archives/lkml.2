Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1HHSBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:01:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1HHSBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:01:43 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 04/11] DIO: Use a slab cache for struct dio
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-5-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 14:01:37 -0400
In-Reply-To: <1312259893-4548-5-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 1 Aug 2011 21:38:06 -0700")
Message-ID: <x49ty9rhjem.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> A direct slab call is slightly faster than kmalloc and can be better cached
> per CPU. It also avoids rounding to the next kmalloc slab.
>
> In addition this enforces cache line alignment for struct dio to avoid
> any false sharing.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
