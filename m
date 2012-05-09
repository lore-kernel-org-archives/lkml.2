Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997Ab2EIXaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:30:13 -0400
Received: from mail.siteground.com ([67.19.240.234]:35311 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab2EIXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:30:08 -0400
X-Greylist: delayed 2371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2012 19:30:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=mtadk; d=siteground.com;
	h=Received:Message-ID:Date:From:Reply-To:Organization:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=HfQCnjs/PzyuB0SNSfk8cJZRHxdFvzEkazi9oD79OqBwAvybe9fBIY7DQsNUEqZAftv5IAvZzwLqYIknrveqLtpr9DtKTkqpmV5BFFZkWSS7GMUv1dMbIwkMvCbvOJup5J8SEN3nc1MYbbzERmPoi0bcIi6pJfsouWWLHT8jCxs=;
Message-ID: <4FAAF4B6.4030507@siteground.com>
Date: Thu, 10 May 2012 01:50:30 +0300
From: Marian Marinov <mm@siteground.com>
Reply-To: mm@siteground.com
Organization: Siteground.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: vaLentin chernoZemski <valentin@siteground.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.2.14 - Sporadic HARD lockups/__slab_free/intel_pmu_handle_irq->perf_event_overflow
References: <4FA8D8A7.8020704@siteground.com> <20120509224411.GA8872@kroah.com>
In-Reply-To: <20120509224411.GA8872@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - siteground.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/10/2012 01:44 AM, Greg KH wrote:
> On Tue, May 08, 2012 at 11:26:15AM +0300, vaLentin chernoZemski wrote:
>>> Kindly Note that kernel is patched against grsec but grsec is not enabled inside the kernel configuration.

Yes, we can.
Unfortunately it is very hard to reproduce the bug. It happens randomly within a month.

Marian
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+q9LMACgkQ4mt9JeIbjJSo6gCeKeS5E0rRfrDaP7mMuKyktDTo
IEQAoKeEVSKXgZUhm/rgOGrGn/x5EvxD
=zOZM
-----END PGP SIGNATURE-----
