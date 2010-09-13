Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0IMFpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 01:45:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0IMFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 01:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=i9rCJwLXCNvO1PWKAKxIK7sLQ1ztJFFEqCOifX4B4gdQTBujrknUkTjW64bRx06Z2u
         gDS+OHTHfb37mDwEW9Mw==
MIME-Version: 1.0
In-Reply-To: <20100913031524.GD7697@localhost>
References: <1284323440-23205-1-git-send-email-mrubin@google.com>
 <1284323440-23205-6-git-send-email-mrubin@google.com> <20100913031524.GD7697@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Sun, 12 Sep 2010 22:45:28 -0700
Message-ID: <AANLkTimCh=10XzoHYtW+3TdejbwXu_x-t8NVV5HXCgsA@mail.gmail.com>
Subject: Re: [PATCH 5/5] writeback: Reporting dirty thresholds in /proc/vmstat
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

On Sun, Sep 12, 2010 at 8:15 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:

> But technical wise, the above two enum items should better be removed
> to avoid possibly eating one more cache line. The two items can be
> printed by explicit code.

Done. Patch coming.

mrubin
