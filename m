Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0H3Q0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:26:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59334 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0H3Q0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=egkcibvdInMgu6ziyS+2nzR9lleZBPVkSigYg7yVM7hjkRn8BecOw2x8Rune0YRCFd
         kFl3KMahDlYAXjAvTeHA==
MIME-Version: 1.0
In-Reply-To: <20100830092446.524B.A69D9226@jp.fujitsu.com>
References: <1282963227-31867-1-git-send-email-mrubin@google.com>
 <1282963227-31867-5-git-send-email-mrubin@google.com> <20100830092446.524B.A69D9226@jp.fujitsu.com>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 30 Aug 2010 09:25:41 -0700
Message-ID: <AANLkTimLwv04pvuz_AtSK3ASr-epD0PeA-vOCigFH8+0@mail.gmail.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, fengguang.wu@intel.com, jack@suse.cz,
        riel@redhat.com, akpm@linux-foundation.org, david@fromorbit.com,
        npiggin@kernel.dk, hch@lst.de, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 5:28 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> afaict, you and wu agreed /debug/bdi/default/stats is enough good.
> why do you change your mention?

I commented on this in the 0/4 email of the bug. I think these belong
in /proc/vmstat but I saw they exist in /debug/bdi/default/stats. I
figure they will probably not be accepted but I thought it was worth
attaching for consideration of upgrading from debugfs to /proc.

mrubin
