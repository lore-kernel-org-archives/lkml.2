Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0HDQxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:53:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39172 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab0HDQxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XHuK/ByaIRqMZSoaXIXToJkbjfMYSW0ABrVmJ5m+UeuWMPga9Z8iNudxKvoKdCX239
         mLPVZkSEiyaxL8fJ3/cHl3JqlllWxbvuXfQLuwmWHMzPiVO64eGs9kI7xrQ/YttYQMIK
         cE96iSEp/NRM6vfhnFjmigmswTzZNrS3scuXE=
Subject: Re: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal
 in mspro_blk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <811063.41186.qm@web37605.mail.mud.yahoo.com>
References: <811063.41186.qm@web37605.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 19:53:41 +0300
Message-ID: <1280940821.16380.10.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 00:50 -0700, Alex Dubov wrote: 
> --- On Tue, 3/8/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > Now that del_gendisk syncs, we better
> > start rejecting requests right away.
> 
> 
> I don't quite see why this change is needed. My understanding is, user
> accessible interface should be marked as removed as early, as possible.

The problem here is that del_gendisk, syncs the device.
This is new change, made after you did your drivers.

I have this problem on jMicron too (which otherwise works fine).


PS:

I have a copy of your ms_block.c.
I would would be very happy if you share with me, what problems does it
still have (besides need of trivial port for changes in block system,
because I want to push it upstream too.

I have MS DUO 64M to test it against.


Best regards,
Maxim Levitsky

