Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab2ARPj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:39:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2ARPj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:39:27 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=qAqWnOW7K_4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=6la1x5fSlxFRSWRs8_oA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326901165.17534.78.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 2/4] wait-simple: Simple waitqueue implementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 18 Jan 2012 10:39:25 -0500
In-Reply-To: <1326894017.12502.7.camel@marge.simson.net>
References: <20120118034531.335521323@goodmis.org>
	 <20120118034700.245278561@goodmis.org>
	 <1326878928.7482.2.camel@marge.simson.net>
	 <1326890703.17534.76.camel@gandalf.stny.rr.com>
	 <1326894017.12502.7.camel@marge.simson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 14:40 +0100, Mike Galbraith wrote:

> I saw compiler warning go zinging by, stopped the build and added the

Thanks, I didn't look for warnings. I'll add the module.h.

> include.  Trying to use the posted patches doesn't work without digging
> out the signature damage, so it was easier to make my own.. and I too

Hmm, I'll stop posting these with gpg sigs.

-- Steve

> just spanked the non-existent include :)


