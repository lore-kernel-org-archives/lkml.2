Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab2IJVhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:37:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2IJVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:37:15 -0400
Date: Mon, 10 Sep 2012 14:37:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, Vivek Goyal <vgoyal@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120910213710.GA7677@google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910213349.GH16360@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 02:33:49PM -0700, Kent Overstreet wrote:
> "Simpler" isn't really an objective thing though. To me the goto version
> is more obvious/idiomatic.
> 
> Eh. I'll do it your way, but consider this a formal objection :p

Thanks. :)

-- 
tejun
