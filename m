Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0GGN3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:29:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47425 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab0GGN3e (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Jul 2010 09:29:34 -0400
Date: Wed, 7 Jul 2010 09:27:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Dave Hansen <dave@sr71.net>, Dan Magenheimer <dan.magenheimer@oracle.com>,
       chris.mason@oracle.com, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org, adilger@Sun.COM, tytso@mit.edu,
       mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
       JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@suse.de,
       dave.mccracken@oracle.com, riel@redhat.com, avi@redhat.com
Subject: Re: [PATCH V3 3/8] Cleancache: core ops functions and configuration
Message-ID: <20100707132744.GB4823@phenom.dumpdata.com>
References: <20100621231939.GA19505@ca-server1.us.oracle.com>
 <1277223988.9782.20.camel@nimitz>
 <20100706205121.GA32627@phenom.dumpdata.com>
 <4C33D240.80102@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C33D240.80102@vflare.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C34811E.00CC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can you reference with a link or a git branch the patches that utilize
> > this?
> > 
> > And also mention that in the 0/X patch so that folks can reference your
> > cleancache implementation?
> > 
> >
> 
> FYI.
> 
> I am working on 'zcache' which uses cleancache_ops to provide page cache
> compression support. I will be posting it to LKML before end of next week.

Yes! That too, please. Thanks for pointing this out.
