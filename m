Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882Ab0GWOBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:01:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39336 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0GWOBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:01:17 -0400
MIME-Version: 1.0
Message-ID: <840b32ff-a303-468e-9d4e-30fc92f629f8@default>
Date: Fri, 23 Jul 2010 06:58:03 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org, Christoph Hellwig <hch@infradead.org>,
        akpm@linux-foundation.org
Cc: Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
        Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@suse.de, Dave Mccracken <dave.mccracken@oracle.com>,
        riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>
Subject: RE: [PATCH V3 0/8] Cleancache: overview
References: <20100621231809.GA11111@ca-server1.us.oracle.com
 4C49468B.40307@vflare.org>
In-Reply-To: <4C49468B.40307@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C49A058.00A3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since zcache is now one of its use cases, I think the major
> objection that remains against cleancache is its intrusiveness
> -- in particular, need to change individual filesystems (even
> though one liners). Changes below should help avoid these
> per-fs changes and make it more self contained.

Hi Nitin --

I think my reply at http://lkml.org/lkml/2010/6/22/202 adequately
refutes the claim of intrusiveness (43 lines!).  And FAQ #2 near
the end of the original posting at http://lkml.org/lkml/2010/6/21/411
explains why the per-fs "opt-in" approach is sensible and necessary.

CHRISTOPH AND ANDREW, if you disagree and your concerns have
not been resolved, please speak up.

Further, the maintainers of the changed filesystems have acked
the very minor cleancache patches; and maintainers of other
filesystems are not affected unless they choose to opt-in,
whereas these other filesystems MAY be affected with your
suggested changes to the patches.

So I think it's just a matter of waiting for the Linux wheels
to turn for a patch that (however lightly) touches a number of
maintainers' code, though I would very much welcome any
input on anything I can do to make those wheels turn faster.

Thanks,
Dan
