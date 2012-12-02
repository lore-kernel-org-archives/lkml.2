Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2LBDMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 22:12:09 -0500
Received: from nctlincom02.orcon.net.nz ([60.234.4.75]:46518 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab2LBDMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 22:12:07 -0500
X-Greylist: delayed 657 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Dec 2012 22:12:07 EST
Date: Sun, 2 Dec 2012 16:00:55 +1300
From: Michael Cree <mcree@orcon.net.nz>
To: David Howells <dhowells@redhat.com>
Cc: rth@twiddle.net, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        mattst88@gmail.com
Subject: Re: [GIT PULL] Disintegrate UAPI for alpha [ver #2]
Message-ID: <20121202030055.GA4687@omega>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
	David Howells <dhowells@redhat.com>, rth@twiddle.net,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	mattst88@gmail.com
References: <21103.1349774108@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21103.1349774108@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Check: by mx6.orcon.net.nz on Sun, 02 Dec 2012 16:01:04 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Dec  2 16:01:07 2012
X-DSPAM-Confidence: 0.5709
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.50] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=G2; city=Porirua; latitude=-41.1333; longitude=174.8500; http://maps.google.com/maps?q=-41.1333,174.8500&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05Iur1nRu - 20573883e335 - 20121202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:15:08AM +0100, David Howells wrote:
> Can you merge the following branch into the alpha tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.

I think the alpha-next tree is currently inactive so nothing has happened
regarding your merge request.

Any chance you could send it directly to Linus?

(A conflict has arisen in arch/alpha/include/asm/Kbuild against Linus'
tree but that is easily resolved.)

FWIW you can have my Acked-By but it would be better if one of the
official Alpha maintainers acknowledged it.

Cheers
Michael.
