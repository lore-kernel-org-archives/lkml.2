Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab2ILTlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:41:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31857 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2ILTlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:41:50 -0400
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org, neilb@suse.de,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 25/26] bio-integrity: Add explicit field for owner of bip_buf
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	<1347322957-25260-26-git-send-email-koverstreet@google.com>
Date: Wed, 12 Sep 2012 15:41:36 -0400
In-Reply-To: <1347322957-25260-26-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Mon, 10 Sep 2012 17:22:36 -0700")
Message-ID: <yq1sjanrpu7.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:

Kent> This was the only real user of BIO_CLONED, which didn't have very
Kent> clear semantics. Convert to its own flag so we can get rid of
Kent> BIO_CLONED.

I already have a patch in my queue that moves all integrity-relevant
flags from struct bio to the bip. So I'm ok with removing BIO_CLONED but
I'll send a separate patch for the integrity flags.

-- 
Martin K. Petersen	Oracle Linux Engineering
