Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1HHSUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:20:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab1HHSUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:20:42 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 07/11] DIO: Merge direct_io_walker into __blockdev_direct_IO
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-8-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 14:20:27 -0400
In-Reply-To: <1312259893-4548-8-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 1 Aug 2011 21:38:09 -0700")
Message-ID: <x49hb5rhij8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> This doesn't change anything for the compiler, but hch thought it would
> make the code clearer.
>
> I moved the reference counting into its own little inline.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


I would've been fine with leaving it as-is... that function's mighty
long.

Anyway, whatever.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
