Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1JJPf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:35:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1JJPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:35:26 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=ccdOYuaMiZkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=HK6bQo87D8s6JdXENwsA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Steven Rostedt <rostedt@goodmis.org>
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, quilt-dev@nongnu.org
Date: Mon, 10 Oct 2011 11:35:23 -0400
In-Reply-To: <1317769149.1662.28.camel@schurl.linbit>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <20111004180237.GA15087@suse.de> <4E8B4BEC.5030708@zytor.com>
	 <1317757101.18063.24.camel@gandalf.stny.rr.com>
	 <4E8B6172.2050006@zytor.com>
	 <1317757696.18063.28.camel@gandalf.stny.rr.com>
	 <1317769149.1662.28.camel@schurl.linbit>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318260925.7904.89.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 00:58 +0200, Andreas Gruenbacher wrote:

> Yes, please.  Also please use Getopt::Long in the Perl script, and
> send a patch relative to the quilt repo. I unfortunately can't help
> with how to beat gpg into behaving right.

Where do I find the official quilt repo? Doing google searches only
leads me to knitting sites. Which is actually quite helpful as the
winter temperatures are coming around the corner.

-- Steve


