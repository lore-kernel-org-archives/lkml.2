Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab2JXV0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:26:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46052 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822Ab2JXV0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:26:42 -0400
Message-ID: <1351114001.7130.5.camel@joe-AO722>
Subject: Re: [BUG] checkpatch.pl with commit
 058806007450489bb8f457b275e5cb5c946320c1
From: Joe Perches <joe@perches.com>
To: jeffrey.t.kirsher@intel.com, Andrew Morton <akpm@linux-foundation.org>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 24 Oct 2012 14:26:41 -0700
In-Reply-To: <1351111870.1917.4.camel@jtkirshe-mobl>
References: <1351076421.25066.14.camel@jtkirshe-mobl>
	 <1351087936.18179.9.camel@joe-AO722>
	 <1351111870.1917.4.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 13:51 -0700, Jeff Kirsher wrote:
> On Wed, 2012-10-24 at 07:12 -0700, Joe Perches wrote:
> > On Wed, 2012-10-24 at 04:00 -0700, Jeff Kirsher wrote:
> > > With the recent commit to checkpatch.pl:
> > > 
> > > commit 058806007450489bb8f457b275e5cb5c946320c1
> > > Author: Joe Perches <joe@perches.com>
> > > Date:   Thu Oct 4 17:13:35 2012 -0700
> > > 
> > >     checkpatch: check networking specific block comment style
> > > 
> > > We are seeing false positive warnings.  Here is an example of the
> > > code the would generate a false warning:
> > > 
> > > #define foo	0x0000 /* foo comment */
> > > 
> > > checkpatch.pl generates a warnings that the */ should be on a separate
> > > line, which in this case is incorrect.
> > 
> > Sorry 'bout that.  I believe it's fixed by:
> > https://lkml.org/lkml/2012/10/14/267
> > 
> 
> Yes, I confirm that the patch in the link you provided solves the issue
> I was seeing.  Thanks, has the patch been accepted yet?  I see it is not
> in Dave's NET tree as of yet.

Andrew Morton generally picks up my checkpatch twiddles.
It's in -next as of next-20121024.

commit db64ad0e6f55197bc3794bef007a25f2db4760fb


