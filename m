Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1AHQ3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 11:29:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33640 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1AHQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 11:29:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tlVxdKn3CZ9PXgJXLbJn58bRVVRjXMACk+v1eDUP5FSEiQFHv4CJf56Gnvt926MAhJ
         1Ox8SRSBA8mRmrhxt/6j4MZIaF1Ii1DZG22gyZ4mABz/hmglqXmLX9QNsNNuVg7EmYIG
         DapJKogi/V+BnbgkjGgpcWuJAfWzp8FrfFldQ=
Date: Sat, 8 Jan 2011 18:29:07 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, ak@linux.intel.com,
        akpm@linux-foundation.org, jonas.aberg@stericsson.com, julia@diku.dk,
        xiyou.wangcong@gmail.com, yann.morin.1998@anciens.enib.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild misc updates for 2.6.38-rc1
Message-ID: <20110108162907.GA4592@p183.telecom.by>
References: <20110107230426.GA15371@sepie.suse.cz>
 <20110107232754.GB8237@pengutronix.de>
 <4D27A329.7010801@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D27A329.7010801@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 08, 2011 at 12:35:05AM +0100, Michal Marek wrote:
> Alexey, how much would it hurt you if the commit stayed as is?

Doesn't matter as long as I can have my prototypes back. :-)
