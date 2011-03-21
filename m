Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1CUB5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 21:57:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1CUB5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 21:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=vLkL1fWjw6pFr8ewwCME4Ss2uYGojKG+7Kr6uhfDL4yCgjunVTXtp3I0c5ERouANp/
         3OypGgzj9QCNu7+J4g6Q==
Date: Sun, 20 Mar 2011 18:57:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Kenny Simpson <theonetruekenny@yahoo.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: remap_file_pages doesn't like MAP_ANONYMOUS (but used to?)
In-Reply-To: <559636.89511.qm@web39404.mail.mud.yahoo.com>
Message-ID: <alpine.LSU.2.00.1103201847030.7192@sister.anvils>
References: <559636.89511.qm@web39404.mail.mud.yahoo.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1742088116-1300672660=:7192"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1742088116-1300672660=:7192
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 20 Mar 2011, Kenny Simpson wrote:
> --- On Sat, 3/19/11, Hugh Dickins <hughd@google.com> wrote:
> > Thanks for reporting.=A0 It was a simple oversight: and
> > until you came
> > along, nobody noticed.=A0 Here's the patch, I'll pass it
> > upstream shortly.
>=20
> Since this bug has existed for a while, could it be pushed back to the va=
rious stable/longterm branches as well? (as they all are affected)
>=20
> Many thanks on the quick response!  Glad it was a simple oversight with a=
n easy and obvious fix.
>=20
> thanks again!
> -Kenny

It's a rare pleasure to be presented with such a straightforward bug!

stable/longterm: well, I don't mind asking akpm to add a Cc: stable,
but don't be surprised if he prefers not: although it was a regression
back in 2.6.23, it's not a security issue, and the lack of interest
between then and now doesn't make a strong argument for it.

Andrew, if you're so inclined, please add a Cc: stable@kernel.org
to [PATCH] shmem: let shared anonymous be nonlinear again

Thanks,
Hugh
--8323584-1742088116-1300672660=:7192--
