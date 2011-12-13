Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab1LMI1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 03:27:14 -0500
Received: from gw1.transmode.se ([195.58.98.146]:37142 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1LMI1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 03:27:13 -0500
In-Reply-To: <20111213063228.GN7137@tux1.beaverton.ibm.com>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201201517.5876.39207.stgit@elm3c44.beaverton.ibm.com> <20111202002505.GB19842@gondor.apana.org.au> <20111203023646.GB16577@tux1.beaverton.ibm.com> <20111212225857.GM7137@tux1.beaverton.ibm.com> <02ea01ccb923$48193ff0$d84bbfd0$@systemfabricworks.com> <20111213063228.GN7137@tux1.beaverton.ibm.com>
Subject: Re: [PATCH 14/14] crc32: Select an algorithm via kconfig
X-KeepSent: 62576D22:A1ACD2B5-C1257965:002E3817;
 type=4; name=$KeepSent
To: djwong@us.ibm.com
Cc: "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Mingming Cao'" <cmm@us.ibm.com>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        "'linux-crypto'" <linux-crypto@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        "'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        "'Theodore Tso'" <tytso@mit.edu>
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OF62576D22.A1ACD2B5-ONC1257965.002E3817-C1257965.002E6F16@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Tue, 13 Dec 2011 09:27:10 +0100
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3|September 15, 2011) at
 12/13/2011 09:27:11
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/12/13 07:32:28:
>
> On Mon, Dec 12, 2011 at 05:10:45PM -0600, Bob Pearson wrote:
> > That choice was for Joakim who measured better performance on his 32 bit PPC
> > platform with "by 4".
>
> Ok.  On my 1.33GHz PowerBook I get ~255MB/s with slice by 4 and ~270MB/s with
> slice by 8.  I think it's a PPC 7447, and definitely 32-bit.  In any case, it
> reports having 32K of L1D cache.

I tested Bobs early version on my mpc8321(266MHz, embedded CPU) and it was just
half the speed compared with current crc32.

 Jocke

