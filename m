Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2JPTCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:02:09 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:48626 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392Ab2JPTCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:02:07 -0400
Date: Tue, 16 Oct 2012 19:02:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Subject: Re: [Q] Default SLAB allocator
In-Reply-To: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
Message-ID: <0000013a6af44832-54f34e60-0e9d-4534-a509-f4171a505671-000000@email.amazonses.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Ezequiel Garcia wrote:

> * Is SLAB a proper choice? or is it just historical an never been re-evaluated?
> * Does the average embedded guy knows which allocator to choose
>   and what's the impact on his platform?

My current ideas on this subject matter is to get to a point where we have
a generic slab allocator framework that allows us to provide any
object layout we want. This will simplify handling new slab allocators that
seems to crop up frequently. Maybe even allow the specification of the
storage layout when the slab is created. Depending on how the memory is
used there may be different object layouts that are most advantageous.


