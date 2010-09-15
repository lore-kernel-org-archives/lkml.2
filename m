Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0IOGS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 02:18:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:6070 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0IOGS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 02:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=V8r3VlONkSBJaapu3Q2FSpctfTrOraR+kmjmkVBxDxdZYPaupJPJSWdTdViJiESzk8
         W8GFbOZinYDd0nd9ksDg==
MIME-Version: 1.0
In-Reply-To: <20100913030256.GC7697@localhost>
References: <1284323440-23205-1-git-send-email-mrubin@google.com>
 <1284323440-23205-5-git-send-email-mrubin@google.com> <20100913030256.GC7697@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Tue, 14 Sep 2010 23:18:03 -0700
Message-ID: <AANLkTinVKWmPUUxu4zHe8X6O-0yh3Hd=WFM5t7WaprTZ@mail.gmail.com>
Subject: Re: [PATCH 4/5] writeback: Adding /sys/devices/system/node/<node>/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 8:02 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Do you have plan to port more vmstat_text[] items? :)

Yes. I feel bound to do it after all your help. :-)
I may need a few weeks to resolve some other issues but I can get back to this.

mrubin
