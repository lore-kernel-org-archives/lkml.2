Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1BIQ7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:59:36 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18696 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab1BIQ7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:59:35 -0500
MIME-Version: 1.0
Message-ID: <d21f1970-225e-4f5a-9e72-97991bd1a2c0@default>
Date: Wed, 9 Feb 2011 08:55:50 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: gregkh@suse.de, Chris Mason <chris.mason@oracle.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, mel@csn.ul.ie, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@ZenIV.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Subject: RE: [PATCH V1 1/3] drivers/staging: kztmem: in-kernel tmem code
References: <20110118171950.GA20460@ca-server1.us.oracle.com
 20110207160253.GA18151@dumpdata.com>
In-Reply-To: <20110207160253.GA18151@dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D52C797.02F3:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Subject: Re: [PATCH V1 1/3] drivers/staging: kztmem: in-kernel tmem
> code
> 
> On Tue, Jan 18, 2011 at 09:19:50AM -0800, Dan Magenheimer wrote:
> > [PATCH V1 1/3] drivers/staging: kztmem: in-kernel tmem code
> 
> Hey Dan,
> 
> I never finished this review, but sending my fragmented comments
> in case the one you posted has overlap.

Thanks Konrad for the thorough review!  I'll fix the nits at the
next version of zcache but will assume (unless you feel otherwise)
that none of these is a showstopper for zcache to be accepted as
a staging driver.

To answer your one question:

> persistent and ephemeral pages can both be in PAM space?

Yes, persistent vs ephemeral is an attribute of the
"struct tmem_pool" and a pointer to the pool is passed
to all PAM callbacks.

Thanks,
Dan
