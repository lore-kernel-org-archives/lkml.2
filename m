Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab0KHPoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:44:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab0KHPoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:44:20 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] dio: add a mempool for the unaligned block structures
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
	<1289202023-15102-4-git-send-email-david@fromorbit.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Nov 2010 10:40:37 -0500
In-Reply-To: <1289202023-15102-4-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Mon, 8 Nov 2010 18:40:23 +1100")
Message-ID: <x49wron962y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> From: Dave Chinner <dchinner@redhat.com>
>
> We need the zero block tracking structure allocation to succeed.
> Silently failing and potentially allowing data corruption is not an
> option. Add a mempool to ensure this allocation will always succeed.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
