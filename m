Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab1JDTfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:35:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59508 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1JDTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:35:24 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=ccdOYuaMiZkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=jyfIP827e4sAxee4ZkYA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Steven Rostedt <rostedt@goodmis.org>
To: Valdis.Kletnieks@vt.edu
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, quilt-dev <quilt-dev@nongnu.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Gruenbacher <agruen@suse.de>
Date: Tue, 04 Oct 2011 15:35:22 -0400
In-Reply-To: <23749.1317756054@turing-police.cc.vt.edu>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <1317754795.32543.32.camel@twins>
	 <23749.1317756054@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317756923.18063.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 15:20 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 04 Oct 2011 20:59:55 +0200, Peter Zijlstra said:
> 
> > How about another option that also allows you to pick they key used for
> > signing things?
> 
> Are there many people that will be signing with a key other than their default key?
> Or is a 'default-key' entry in ~/.gnupg/gpg.conf sufficient?
> 

Until I switched my default key, I was.

-- Steve



