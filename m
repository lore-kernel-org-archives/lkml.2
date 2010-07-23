Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740Ab0GWRp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:45:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31497 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab0GWRpT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:45:19 -0400
MIME-Version: 1.0
Message-ID: <537098fb-f049-482a-97cf-b3695bf2c340@default>
Date: Fri, 23 Jul 2010 10:43:17 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
        Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        adilger@Sun.COM, tytso@mit.edu, mfasheh@suse.com,
        Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@suse.de, Dave Mccracken <dave.mccracken@oracle.com>,
        riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>
Subject: RE: [PATCH V3 0/8] Cleancache: overview
References: <20100621231809.GA11111@ca-server1.us.oracle.com4C49468B.40307@vflare.org>
 <840b32ff-a303-468e-9d4e-30fc92f629f8@default>
 <20100723140440.GA12423@infradead.org>
 <364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default 4C49AFAE.1070300@vflare.org>
In-Reply-To: <4C49AFAE.1070300@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C49D4F8.0075:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nitin Gupta [mailto:ngupta@vflare.org]
> Sent: Friday, July 23, 2010 9:05 AM
> To: Dan Magenheimer
> Cc: Christoph Hellwig; akpm@linux-foundation.org; Chris Mason;
> viro@zeniv.linux.org.uk; adilger@sun.com; tytso@mit.edu;
> mfasheh@suse.com; Joel Becker; matthew@wil.cx; linux-
> btrfs@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> fsdevel@vger.kernel.org; linux-ext4@vger.kernel.org; ocfs2-
> devel@oss.oracle.com; linux-mm@kvack.org; jeremy@goop.org;
> JBeulich@novell.com; Kurt Hackel; npiggin@suse.de; Dave Mccracken;
> riel@redhat.com; avi@redhat.com; Konrad Wilk
> Subject: Re: [PATCH V3 0/8] Cleancache: overview
> 
> On 07/23/2010 08:14 PM, Dan Magenheimer wrote:
> >> From: Christoph Hellwig [mailto:hch@infradead.org]
> 
> 
> >> Also making the ops vector global is just a bad idea.
> >> There is nothing making this sort of caching inherently global.
> >
> > I'm not sure I understand your point, but two very different
> > users of cleancache have been provided, and more will be
> > discussed at the MM summit next month.
> >
> > Do you have a suggestion on how to avoid a global ops
> > vector while still serving the needs of both existing
> > users?
> 
> Maybe introduce cleancache_register(struct cleancache_ops *ops)?
> This will allow making cleancache_ops non-global. No value add
> but maybe that's cleaner?

Oh, OK, that seems reasonable.

Dan
