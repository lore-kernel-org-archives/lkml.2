Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab0HFAMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:12:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54611 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab0HFAL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:11:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:x-system-of-record;
	b=b6ULW0wKyG8TSoLDyqltCi+N8raN+oY1Hi8zMLUdD4j53YeL+1MbJ+JDXlZNt2QlH
	6F9Yg+kTESdsjLI+TnDkQ==
MIME-Version: 1.0
In-Reply-To: <20100806084928.31DE.A69D9226@jp.fujitsu.com>
References: <20100805132433.d1d7927b.akpm@linux-foundation.org> 
	<AANLkTik9AMf1pmsguB843UC9Qq6KxBcWiN_qyeiDPp1O@mail.gmail.com> 
	<20100806084928.31DE.A69D9226@jp.fujitsu.com>
From: Michael Rubin <mrubin@google.com>
Date: Thu, 5 Aug 2010 17:11:35 -0700
Message-ID: <AANLkTimD4jkkPpnhQhR+OF=6=dWV2dJj4M_DGfAmHgRQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] writeback: Adding pages_dirtied and 
	pages_entered_writeback
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
        david@fromorbit.com, hch@lst.de, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 4:56 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> /proc/vmstat already have both.
>
> cat /proc/vmstat |grep nr_dirty
> cat /proc/vmstat |grep nr_writeback
>
> Also, /sys/devices/system/node/node0/meminfo show per-node stat.
>
> Perhaps, I'm missing your point.

These only show the number of dirty pages present in the system at the
point they are queried.
The counter I am trying to add are increasing over time. They allow
developers to see rates of pages being dirtied and entering writeback.
Which is very helpful.

mrubin
