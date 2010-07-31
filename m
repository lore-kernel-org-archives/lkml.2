Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0GaSly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 14:41:54 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25909 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab0GaSlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 14:41:52 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=Ksu0FrVsbPQA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=IfaOZ6jVqMvABnLcbRsA:9
 a=8argCpq2DmyQ75d_PlHmHIp2UtUA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1280513506.12852.22.camel@heimdal.trondhjem.org>
Date: Sat, 31 Jul 2010 12:41:41 -0600
Cc: Phil Pishioneri <pgp@psu.edu>, Volker.Lendecke@SerNet.DE,
        Jeremy Allison <jra@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jan Engelhardt <jengelh@medozas.de>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <09B770A6-48DB-4296-B6C2-BF46D4DC7E57@dilger.ca>
References: <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE> <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com> <E1Obxpd-00CRIo-SF@intern.SerNet.DE> <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com> <20100722162712.GB10352@jeremy-laptop> <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com> <1279817930.3621.14.camel@heimdal.trondhjem.org> <20100722180204.GA32008@samba1> <E1Oc08W-00CZuz-Ns@intern.SerNet.DE> <1279825160.3621.71.camel@heimdal.trondhjem.org> <4C5311F4.2050100@psu.edu> <1280513506.12852.22.camel@heimdal.trondhjem.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-30, at 12:11, Trond Myklebust wrote:
> Your Mac has a perfectly functional CIFS client, as do your Linux boxes.
> They both interoperate just fine with Samba, and would presumably
> continue to do so if someone were to decide to reuse the ctime field on
> your Samba box as storage for a create time.

CIFS doesn't support symlinks (they just appear as the referenced file), so I've had applications that scan the filesystem recurse indefinitely due to symlinked directories on a CIFS share appearing as hard-linked directories on the client.  This doesn't happen when the filesystem is accessed via NFS.

Cheers, Andreas





