Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab1ESRjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:39:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41333 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933649Ab1ESRjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E800DHicLQvienaA9DSCkpEp+mVtaY/uLY4STjpOh/4mUMMns1QgQHjwyH7vkP2oxU
         f6ue2eg1NbSrwnbYxmuTI5GIguyOm88hLBwBwaDGUi4ymexfnpb4CJnudZu0lhpeKPy2
         YDBQWA+V+eGhq2wwqAKWVdVc8/vKDQcJGE3hM=
MIME-Version: 1.0
In-Reply-To: <20110519093026.GA627@htj.dyndns.org>
References: <BANLkTin3T8msxSSbTLJOvC5WLNFGspPEcg@mail.gmail.com>
	<20110519093026.GA627@htj.dyndns.org>
Date: Thu, 19 May 2011 10:39:43 -0700
Message-ID: <BANLkTinP7txzE2U+8qnJR2JVcGpGybnLrA@mail.gmail.com>
Subject: Re: New boot time message: detected capacity change
From: Tony Luck <tony.luck@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 2:30 AM, Tejun Heo <tj@kernel.org> wrote:
> Yes, it is harmless.  The order was changed between
> rescan_partitions() and bd_set_size() - rescan_partitions() checked
> for size change too and it resulted in simpler condition checks.
> However, rescan_partitions() triggers the above message when it
> detects size change unlike the silient bd_set_size().
>
> Does the following patch remove the messages for you?

Yes - messages are gone with this patch applied.

Thanks

-Tony
