Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1G0VWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:22:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57806 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755069Ab1G0VWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:22:00 -0400
X-Authenticated: #11967524
X-Provags-ID: V01U2FsdGVkX1+Hm6FALiKHQ1ZlugwS9myyNPb1OedmtvEHWnTY+v
	y6bP2ew9PHdef0
From: =?iso-8859-1?q?R=FCdiger_Meier?= <sweet_f_a@gmx.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Date: Wed, 27 Jul 2011 23:21:45 +0200
User-Agent: KMail/1.9.10
Cc: Bryan Schumaker <bjschuma@netapp.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan> <201107272227.03265.sweet_f_a@gmx.de> <20110727204724.GA21314@infradead.org>
In-Reply-To: <20110727204724.GA21314@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107272321.54030.sweet_f_a@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 July 2011, Christoph Hellwig wrote:
> On Wed, Jul 27, 2011 at 10:26:55PM +0200, R?diger Meier wrote:
> > At the time I've started this thread
> > http://comments.gmane.org/gmane.linux.nfs/40863
> > I had the feeling that the readdir cache changings in 2.6.37 have
> > something to do with these loop problems.
> >
> > After that thread I've accepted that's a general problem with
> > ext4/dirindex and nfs but seeing it again on xfs with just 5000
> > files I'm in doubt again.
>
> Two separate issues. [...]

Yup, I didn't wanted to say that I'm in doubt about the general 
ext4/dirindex problem but I'am still in doubt about the complete 
innocence of readdir cache.

I guess I've run into both issues at that time. I remember that I 
couldn't easily create such "broken" dir from scratch but my users 
managed it to have dozens of them, often just about 30000 files.
Somehow it seemed to be important that the dirs were growing in a 
natural way.

However no probs again since with xfs and ext4 without dirindex. But 
still the feeling that upgrading to 2.6.37 was also a part of the 
problem.

cu,
Rudi

