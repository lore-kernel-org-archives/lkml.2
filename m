Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab0K3Dzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:55:50 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34351 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0K3Dzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:55:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Eu71GuuIf/pgz4Dstyerpc2JkJODt1wKzI88aRVST1xAGzOInj+n2ESbnw1mE3BBee
         AgDtQMY5aEsYht1tWeUuloHn7OW8dqQtxbHu2tLNoDQFnqvkHZd7sGt3QKD2VXT3RSFo
         FFjqsBXAcgPn5Zfq9V8MmKRI3aNyY9pBY7FXU=
MIME-Version: 1.0
In-Reply-To: <20101129103845.GA1195@localhost>
References: <20101129103845.GA1195@localhost>
Date: Tue, 30 Nov 2010 12:55:48 +0900
Message-ID: <AANLkTikQuhq0GMjiSUdctq_qSbJdZss_6pZkAZuF1Rck@mail.gmail.com>
Subject: Re: [BUGFIX] vmstat: fix dirty threshold ordering
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 7:38 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> The nr_dirty_[background_]threshold fields are misplaced before the
> numa_* fields, and users will read strange values.
>
> This is the right order. Before patch, nr_dirty_background_threshold
> will read as 0 (the value from numa_miss).
>
>        numa_hit 128501
>        numa_miss 0
>        numa_foreign 0
>        numa_interleave 7388
>        numa_local 128501
>        numa_other 0
>        nr_dirty_threshold 144291
>        nr_dirty_background_threshold 72145
>
> Cc: Michael Rubin <mrubin@google.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
