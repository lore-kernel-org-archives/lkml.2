Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab2B1Pdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:33:51 -0500
Received: from mail16.primus.ca ([216.254.141.183]:39381 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752470Ab2B1Pdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:33:49 -0500
Message-ID: <4F4CF3CF.5090605@bell.net>
Date: Tue, 28 Feb 2012 10:33:35 -0500
From: John David Anglin <dave.anglin@bell.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "kyle@mcmartin.ca" <kyle@mcmartin.ca>, "deller@gmx.de" <deller@gmx.de>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE
 for 64 bit.
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com> <201202280106.23643.vapier@gentoo.org> <1330438245.2822.114.camel@dabdike.int.hansenpartnership.com> <201202281021.05897.vapier@gentoo.org>
In-Reply-To: <201202281021.05897.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated: danglin-lux@magma.ca - 216-58-40-249.cpe.distributel.net ([192.168.0.181]) [216.58.40.249]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/28/2012 10:21 AM, Mike Frysinger wrote:
> we've been using hppa2.0 for years.  gnuconfig certainly recognizes it:
> $ grep hppa /usr/share/gnuconfig/config.sub
>          | h8300 | h8500 | hppa | hppa1.[01] | hppa2.0 | hppa2.0[nw] | hppa64 \
>          | hppa-* | hppa1.[01]-* | hppa2.0-* | hppa2.0[nw]-* | hppa64-* \
>
> and i've seen diff projects key off of the hppa2.0* to enable newer features by
> default.
Some of the above are specific to HP-UX, but hppa1.1, hppa2.0, hppa and 
hppa64 are
valid for Linux based on config.guess.

Dave

-- 
John David Anglin    dave.anglin@bell.net

