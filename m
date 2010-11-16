Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0KPRZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:25:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab0KPRZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:25:45 -0500
MIME-Version: 1.0
In-Reply-To: <20101116071029.GA13540@havoc.gtf.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
 <20101113051635.GA11613@havoc.gtf.org> <20101116071029.GA13540@havoc.gtf.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 09:25:21 -0800
Message-ID: <AANLkTi=GGq0tMAWtwa-yQBpmpA8JCSWu1XK1rQ2j_Cmo@mail.gmail.com>
Subject: Re: [PATCH v5] SCSI host lock push-down
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:10 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Move the mid-layer's ->queuecommand() invocation from being locked
> with the host lock to being unlocked to facilitate speeding up the
> critical path for drivers who don't need this lock taken anyway.

Looks ok to me. How should I take this? Just as a patch? Or should it
go through the scsi tree?

                   Linus
