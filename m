Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1K3NtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:49:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab1K3NtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:49:09 -0500
Date: Wed, 30 Nov 2011 13:48:34 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>
Cc: esandeen@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Message-ID: <20111130134834.GW7595@agk-dp.fab.redhat.com>
Mail-Followup-To: Jan Kara <jack@suse.cz>,
	Mikulas Patocka <mpatocka@redhat.com>, esandeen@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	Valerie Aurora <val@vaaconsulting.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com> <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com> <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com> <20111129101901.GA5635@quack.suse.cz> <20111130133332.GV7595@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130133332.GV7595@agk-dp.fab.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 01:33:32PM +0000, Alasdair G Kergon wrote:
> Have I missed something in this
> reasoning, Mikulas?
 
Ah - counter-example: mmap?
So sync might indeed be required to block on the filesystem iff there
are newly-dirtied pages.

Alasdair

