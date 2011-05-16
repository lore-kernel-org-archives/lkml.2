Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1EPSpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:45:15 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:48479 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751013Ab1EPSpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:45:13 -0400
Date: Mon, 16 May 2011 20:45:10 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Frank Arnold <farnold@amd64.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/3] x86, AMD, cacheinfo: Fix fallout caused by max3
 conversion
Message-ID: <20110516184510.GA3290@nuttenaction>
References: <1305553188-21061-1-git-send-email-bp@amd64.org>
 <1305553188-21061-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305553188-21061-2-git-send-email-bp@amd64.org>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>732eacc0542d0aa48797f675888b85d6065af837 converted code around the
>kernel using nested max() macros to use the new max3 macro but forgot to
>remove the old line in intel_cacheinfo.c. Fix it.
>
>Cc: Hagen Paul Pfeifer <hagen@jauu.net>
>Cc: Frank Arnold <farnold@amd64.org>
>Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Argl, sorry for that!

Acked-by: Hagen Paul Pfeifer <hagen@jauu.net>
