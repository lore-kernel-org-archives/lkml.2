Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2K2Uyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:54:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:32866 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2K2Uyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:54:49 -0500
Date: Thu, 29 Nov 2012 21:54:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Benjamin LaHaise <bcrl@kvack.org>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
Message-ID: <20121129205447.GY16230@one.firstfloor.org>
References: <m28v9kgsen.fsf@firstfloor.org> <20121129185720.GE15094@google.com> <20121129185953.GW16230@one.firstfloor.org> <20121129191214.GG15094@google.com> <20121129192003.GX16230@one.firstfloor.org> <20121129192925.GH15094@google.com> <20121129193452.GI19042@kvack.org> <20121129202231.GJ15094@google.com> <m2fw3sf8eu.fsf@firstfloor.org> <20121129204531.GK15094@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129204531.GK15094@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The regular atomic_t is limited in ways that you are not.
> > See my original mail.
> 
> I don't follow, can you explain?

For most cases the reference count is tied to some object, which are
naturally limited by memory size or other physical resources.

But in the assymetric CPU case with your ref count no such limiter
exists.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
