Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab0HEATN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:19:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230Ab0HEATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:19:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:x-system-of-record;
	b=C4PkDhzA7V2+Il9sqWwS8FvntqQSl0IsOx3CJsifduekufjx320xA0G4nLiio2VHG
	sKcE5ftHlf87jiXxCnjig==
MIME-Version: 1.0
In-Reply-To: <20100804150422.c52b308e.akpm@linux-foundation.org>
References: <1280873949-20460-1-git-send-email-mrubin@google.com> 
	<20100804150422.c52b308e.akpm@linux-foundation.org>
From: Michael Rubin <mrubin@google.com>
Date: Wed, 4 Aug 2010 17:18:46 -0700
Message-ID: <AANLkTikXWJCde+rQ6W7v8N_HhT62p0wa50Ca+Xez4EoV@mail.gmail.com>
Subject: Re: [PATCH 0/2] Adding four writeback files in /proc/sys/vm
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 3:04 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> For pages_dirtied and pages_entered_writeback: it's hard to see how any
> reimplementation of writeback would have any problem implementing
> these, so OK.

>
> But dirty_threshold_kbytes and dirty_background_threshold_kbytes are
> closely tied to the implementation-of-the-day and so I don't think they
> should be presented in /proc.

OK I will resend patch without threshold and then look for the write
place in debugfs to put them in a subsequent patch.

Thanks,

mrubin
