Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0JZCPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:15:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51346 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab0JZCO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tXTJQawIqL3gT0KCd+Xw1E6GfAf9CCqx0yQrDj3cISq126wokoeTEvX0wsGrdQFfDe
         UmiB8tTcjmc5r1N0hSKCNlI7sZ/Ee45LD7iq5yRkDIiYta02cRaYxgWC9x8yD3J8cq3n
         X4yN0w/piJuvGkhVCw5t4LvuxDwll+dHssOig=
Subject: Re: [PATCH 17/29] memstick: jmb38x_ms: move "reg_data" functions
 together.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <237904.5831.qm@web37607.mail.mud.yahoo.com>
References: <237904.5831.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 04:14:54 +0200
Message-ID: <1288059294.4024.153.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 09:00 -0700, Alex Dubov wrote:
> 
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 17/29] memstick: jmb38x_ms: move "reg_data" functions together.
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > No functional changes, just group
> > these funtions together.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> 
> As before, patch with dubious utility.
But no harm ether, no?

Just makes code a bit easier to read.
Again that patch was done to minimize diff w/original when I was
splitting patches.
If you really are againt it, I can revert that.

Best regards,
	Maxim Levitsky

