Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0CYRVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:21:45 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:42636 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752281Ab0CYRVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:21:44 -0400
Date: Thu, 25 Mar 2010 13:21:37 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@sunset.davemloft.net
Subject: Re: Question about e06e7c615877026544ad7f8b309d1a3706410383 --
 [IPV4]: The scheduled removal of multipath cached routing support.
Message-ID: <20100325172137.GA12751@elliptictech.com>
Mail-Followup-To: Richard Hartmann <richih.mailinglist@gmail.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	davem@sunset.davemloft.net
References: <2d460de71003251011y2d8d1931u683b396f40df4ed1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d460de71003251011y2d8d1931u683b396f40df4ed1@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:11 Thu 25 Mar     , Richard Hartmann wrote:
> I was wondering what the rationale for commit
> e06e7c615877026544ad7f8b309d1a3706410383 is. We upgraded our custom
> image to 2.6.33 recently and found those options to be missing.

>From the diff of that commit:

-What:	Multipath cached routing support in ipv4
-When:	in 2.6.23
-Why:	Code was merged, then submitter immediately disappeared leaving
-	us with no maintainer and lots of bugs.  The code should not have
-	been merged in the first place, and many aspects of it's
-	implementation are blocking more critical core networking
-	development.  It's marked EXPERIMENTAL and no distribution
-	enables it because it cause obscure crashes due to unfixable bugs
-	(interfaces don't return errors so memory allocation can't be
-	handled, calling contexts of these interfaces make handling
-	errors impossible too because they get called after we've
-	totally commited to creating a route object, for example).
-	This problem has existed for years and no forward progress
-	has ever been made, and nobody steps up to try and salvage
-	this code, so we're going to finally just get rid of it.
-Who:	David S. Miller <davem@davemloft.net>

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
