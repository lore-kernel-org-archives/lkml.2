Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0LISB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:01:29 -0500
Received: from THUNK.ORG ([69.25.196.29]:57199 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab0LISB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:01:26 -0500
Date: Thu, 9 Dec 2010 13:01:11 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Jon Nelson <jnelson@jamponi.net>
Cc: Mike Snitzer <snitzer@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Matt <jackdachef@gmail.com>, Milan Broz <mbroz@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun@gmail.com,
        linux-ext4@vger.kernel.org
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Message-ID: <20101209180111.GF2921@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Jon Nelson <jnelson@jamponi.net>, Mike Snitzer <snitzer@redhat.com>,
	Chris Mason <chris.mason@oracle.com>, Matt <jackdachef@gmail.com>,
	Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun@gmail.com,
	linux-ext4@vger.kernel.org
References: <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think>
 <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com>
 <20101207193514.GA2921@thunk.org>
 <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim8UTkfxXV0AkEfjNq3tcmnrXdh6BQ1ibY5iYPy@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 09:37:20PM -0600, Jon Nelson wrote:
> One difference is the location of the transaction logs (pg_xlog). In
> my case, /var/lib/pgsql/data *is* mountpoint for the test volume
> (actually, it's a symlink to the mount point). In your case, that is
> not so. Perhaps that makes a difference?  pgsql_tmp might also be on
> two different volumes in your case (I can't be sure).

I just tried tried to run t.sql five times with /var/lib/postgres as a
mountpoint for a 5400 rpm disk, and I still haven't been able to
replicate it.

If you can point out how to query pgsql_tmp (I'm using a completely
default postgres install), that would be helpful, but I don't think it
would be going anywhere else.

Still trying....

						- Ted
