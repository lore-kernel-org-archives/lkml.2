Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2FMUbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:31:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54872 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2FMUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:31:09 -0400
Date: Wed, 13 Jun 2012 22:31:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v2
Message-ID: <20120613203103.GG11413@one.firstfloor.org>
References: <1339542816-21663-1-git-send-email-andi@firstfloor.org> <4FD8F70F.7080405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD8F70F.7080405@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 04:24:47PM -0400, Rik van Riel wrote:
> This would also be useful for emulators such as qemu-kvm,
> which want the guest memory to be 2MB aligned.

hugetlbfs does implicit align, so right now I mash
the two together and use up many of the remaining bits

If you want align different than page sizes you may need
to go 64bits with the flags.

Is there a use case for alignment independent of page sizes?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
