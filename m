Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab1EaOwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:52:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24815 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1EaOwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:52:11 -0400
MIME-Version: 1.0
Message-ID: <790b3e0b-14b6-44da-9f4c-a4315b58e2c5@default>
Date: Tue, 31 May 2011 07:51:36 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Joel Becker <jlbec@evilplan.org>, Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sunil Mushran <sunil.mushran@oracle.com>
Subject: RE: Cleancache and shared filesystems
References: <1306504300.2857.14.camel@menhir>
 <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default>
 <1306513179.2857.38.camel@menhir
 20110527233331.GC30232@noexit.corp.google.com>
In-Reply-To: <20110527233331.GC30232@noexit.corp.google.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4DE5008E.000A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joel Becker [mailto:jlbec@evilplan.org]
> Sent: Friday, May 27, 2011 5:34 PM
> To: Steven Whitehouse
> Cc: Dan Magenheimer; linux-kernel@vger.kernel.org; Sunil Mushran
> Subject: Re: Cleancache and shared filesystems
> 
> On Fri, May 27, 2011 at 05:19:39PM +0100, Steven Whitehouse wrote:
> > +	if (ls->ls_ops == &gfs2_dlm_ops) {
> > +		if (gfs2_uuid_valid(sb->s_uuid))
> > +			cleancache_init_shared_fs(sb->s_uuid, sb);
> > +	} else {
> > +		cleancache_init_fs(sb);
> > +	}
> 
> Hey Dan,
> 	Steven makes a good point here.  ocfs2 could also take advantage
> of local filesystem behavior when running in local mode.

Hi Joel --

I guess the semantics need to be more clearly defined
(or perhaps changed if the shared-fs community wants),
but if cleancache_init_shared_fs is called only by
a single node, cleancache still enables all the same
functionality** as cleancache_init_fs. 

I'm not sure I fully understand the semantics of
local mode though, so please clarify if you think
I am wrong or misunderstanding your point.

Thanks,
Dan

---
Thanks... for the memory!
I really could use more / my throughput's on the floor
The balloon is flat / my swap disk's fat / I've OOM's in store
Overcommitted so much
(with apologies to Bob Hope)
