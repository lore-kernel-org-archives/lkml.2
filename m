Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1BCMKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 07:10:30 -0500
Received: from stinky.trash.net ([213.144.137.162]:55144 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab1BCMK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 07:10:28 -0500
Message-ID: <4D4A9B30.8010805@trash.net>
Date: Thu, 03 Feb 2011 13:10:24 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [GIT PULL] IPVS SCTP lock fix
References: <1296733925-23131-1-git-send-email-horms@verge.net.au>
In-Reply-To: <1296733925-23131-1-git-send-email-horms@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.02.2011 12:52, schrieb Simon Horman:
> Hi Patrick,
> 
> please consider pulling
> git://git.kernel.org/pub/scm/linux/kernel/git/horms/lvs-test-2.6.git for-patrick
> which contains a single patch to the IPVS SCTP module so that
> it uses the correct lock.

Pulled, thanks Simon.
