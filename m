Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HHTqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1HHTqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:46:34 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/11] DIO: Separate fields only used in the submission path from struct dio
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-2-git-send-email-andi@firstfloor.org>
	<x497h6niy37.fsf@segfault.boston.devel.redhat.com>
	<20110808194300.GN5782@one.firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 15:46:27 -0400
In-Reply-To: <20110808194300.GN5782@one.firstfloor.org> (Andi Kleen's message
	of "Mon, 8 Aug 2011 21:43:00 +0200")
Message-ID: <x49r54vfzzg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> The pages array is only used on submission.  Why did it land in the
>> struct dio? 
>
> It's too large for the stack.

Heh.  Right...

Acked-by: Jeff Moyer <jmoyer@redhat.com>
