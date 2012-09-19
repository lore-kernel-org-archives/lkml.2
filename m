Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2ITAmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 20:42:14 -0400
Received: from ozlabs.org ([203.10.76.45]:50506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab2ITAmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 20:42:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@linuxfoundation.org>, Michael Tokarev <mjt@tls.msk.ru>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alex Lyashkov <umka@cloudlinux.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lve module taint?
In-Reply-To: <20120919071942.GF16905@kroah.com>
References: <87sjaepy67.fsf@rustcorp.com.au> <50595EF1.6050003@msgid.tls.msk.ru> <20120919071942.GF16905@kroah.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 20 Sep 2012 08:29:02 +0930
Message-ID: <877grppqkp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> On Wed, Sep 19, 2012 at 09:58:09AM +0400, Michael Tokarev wrote:
>> On 19.09.2012 06:02, Rusty Russell wrote:
>> This is setting a, in my opinion, rather bad precedent.  Next we'll
>> be adding various modules here due to various reasons.

We have, that bridge has already been crossed.  I wasn't asking about
the patch itself.

My question was simply whether the lve module is still claiming to be
GPL without being compliant or not.

Cheers,
Rusty.
