Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab2EWPOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:14:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2EWPOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:14:38 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_2gBi4Ny9w4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=OA39FpFkUs2GtTTHs2IA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337786077.13348.161.camel@gandalf.stny.rr.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 23 May 2012 11:14:37 -0400
In-Reply-To: <20120523150540.GA2016@redhat.com>
References: <1334720611.28106.25.camel@gandalf.stny.rr.com>
	 <20120418035004.GA31465@redhat.com>
	 <1334721441.28106.28.camel@gandalf.stny.rr.com>
	 <20120418040632.GB31465@redhat.com>
	 <1334722164.28106.31.camel@gandalf.stny.rr.com>
	 <20120418135815.GA10798@redhat.com>
	 <1334760965.28106.39.camel@gandalf.stny.rr.com>
	 <20120418153002.GB17558@redhat.com>
	 <1334767425.28106.43.camel@gandalf.stny.rr.com>
	 <1337783828.13348.158.camel@gandalf.stny.rr.com>
	 <20120523150540.GA2016@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 11:05 -0400, Dave Jones wrote:

> But! Linus' current tree seems to have working tracing on that box.
> Don't break it again! ;-)

You could install ktest and run a reverse bisect to find out what fixed
it ;-)

-- Steve


