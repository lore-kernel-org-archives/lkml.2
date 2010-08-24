Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0HXCFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:05:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:9236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab0HXCFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IuzwZlTFDHdZtU3tK+iN5AhzbY3nXRMuThlB4isWQBiUcwYPIemh6gGAaOWSCiY1aT
         lCAswJ4dglxcLlU1ePFg==
MIME-Version: 1.0
In-Reply-To: <20100824020136.GA9536@localhost>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
 <1282296689-25618-5-git-send-email-mrubin@google.com> <20100824020136.GA9536@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 23 Aug 2010 19:04:39 -0700
Message-ID: <AANLkTim8cDKnBSgJs=_FwXj1SrjQ5PhyrT4HjbXAmytw@mail.gmail.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 7:01 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> +     global_dirty_limits(v + NR_DIRTY_THRESHOLD, v + NR_DIRTY_BG_THRESHOLD);
>
> Sorry I messed it up. The parameters should be swapped.

Got it. Thanks.

mrubin
