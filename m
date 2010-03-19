Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0CSRSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 13:18:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42214 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0CSRSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 13:18:41 -0400
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add PGM protocol support to the IP stack
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.2.00.1003181245050.23010@router.home>
Date: Fri, 19 Mar 2010 18:18:36 +0100
In-Reply-To: <alpine.DEB.2.00.1003181245050.23010@router.home> (Christoph Lameter's message of "Thu, 18 Mar 2010 12:58:48 -0500 (CDT)")
Message-ID: <87tysccjrn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:
>
> I know about the openpgm implementation. Openpbm does this at the user
> level and requires linking to a library. It is essentially a communication
> protocol done in user space. It has privilege issues because it has to
> create PGM packets via a raw socket.

That seems like a poor reason alone to put something into the kernel
Perhaps you rather need some way to have unpriviledged raw sockets?

The classical way to do this is to start suid root, only open
the socket and then drop privileges.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
