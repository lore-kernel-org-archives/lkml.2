Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab2HGMlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:41:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44251 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2HGMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120806155433.GB4850@dhcp22.suse.cz>
References: <CAJd=RBC9HhKh5Q0-yXi3W0x3guXJPFz4BNsniyOFmp0TjBdFqg@mail.gmail.com>
	<20120806132410.GA6150@dhcp22.suse.cz>
	<CAJd=RBCuvpG49JcTUY+qw-tTdH_vFLgOfJDE3sW97+M04TR+hg@mail.gmail.com>
	<20120806155433.GB4850@dhcp22.suse.cz>
Date: Tue, 7 Aug 2012 20:41:15 +0800
Message-ID: <CAJd=RBDoGwnMHKDpTKZF7Nq3VegttmCMXa2PjOrnPcCxwFKdiQ@mail.gmail.com>
Subject: Re: [patch v2] hugetlb: correct page offset index for sharing pmd
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 11:54 PM, Michal Hocko <mhocko@suse.cz> wrote:
> It's just that page_table_shareable fix the index silently by saddr &
> PUD_MASK.

Follow no up, and see no wrong in page_table_shareable frankly.

Hillf
