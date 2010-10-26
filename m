Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0JZBuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:50:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53670 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0JZBuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xRsvHzHrOIkhhph5tABm7Zcdi+a0z0OjUV8Ph6oZo+69LxTtZhvOKVwFVF7jGEfiNc
         iEGiE69pHYWSAk2zPO/K/VtoM11cZuojHFKmL0ruFsoM5U5HTCrxG8WE6L1CEZBeMI/G
         vvmMo0Gk16LJ1ACTU0OU2AWpUcHRzc/nt13Mg=
Subject: Re: [PATCH 06/29] memstick: mspro: kill the BKL
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <785156.30720.qm@web37604.mail.mud.yahoo.com>
References: <785156.30720.qm@web37604.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:50:06 +0200
Message-ID: <1288057806.4024.98.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:12 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 06/29] memstick: mspro: kill the BKL
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > mspro_block_disk_lock already
> > protects the code.
> > 
> 
> It is indeed, but I don't see the functionality this patch is trying to
> revert neither in my running kernel (2.6.32.8) nor in current git tree.

This patch is against 2.6.35 which moved BKL from core to drivers so
that maintainers could take action.
Actually due to lack of action from memstick maintainers, this patch
doesn't apply to mainline as now BKL is replaced with yet another
unnecessary mutex.
I have a patch to remove it.

Best regards,
	Maxim Levitsky

