Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2AZDTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 22:19:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41607 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2AZDTT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 22:19:19 -0500
MIME-Version: 1.0
In-Reply-To: <20120125170054.affb676b.akpm@linux-foundation.org>
References: <CAJd=RBDVxT5Pc2HZjz15LUb7xhFbztpFmXqLXVB3nCoQLKHiHg@mail.gmail.com>
	<20120123170354.82b9f127.akpm@linux-foundation.org>
	<CAJd=RBByNhLSiBtyaYOHeMRQpXmAO=hEKTOanPTzrb2gRZTOSg@mail.gmail.com>
	<20120125170054.affb676b.akpm@linux-foundation.org>
Date: Thu, 26 Jan 2012 11:19:17 +0800
Message-ID: <CAJd=RBCv1F3oWpnEbqrvOaRzg_G6Xj_PPHP8v6OADL=vH2pt8g@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: fix malused nr_reclaimed in shrinking zone
From: Hillf Danton <dhillf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

On Thu, Jan 26, 2012 at 9:00 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> I'm thinking we have a bit of code rot happening here.  This comment:
>
>                /*
>                 * On large memory systems, scan >> priority can become
>                 * really large. This is fine for the starting priority;
>                 * we want to put equal scanning pressure on each zone.
>                 * However, if the VM has a harder time of freeing pages,
>                 * with multiple processes reclaiming pages, the total
>                 * freeing target can get unreasonably large.
>                 */
>
> seems to have little to do with the code which it is trying to
> describe.  Or at least, I'm not sure this is the best we can possibly
> do :(
>

Try to do it soon 8-)

>
> Also, your email client is adding MIME goop to the emails which mine
> (sylpheed) is unable to decrypt.  It turns "=" into "=3D" everywhere.
> This:
>
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: quoted-printable
>
> I blame sylpheed for this, but if you can make it stop, that would make
> my life easier, and perhaps others.
>

More care will take gmail later on.

Thanks
Hillf
