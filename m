Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab2DIVM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:12:57 -0400
Received: from mta02.ornl.gov ([128.219.14.62]:56172 "EHLO mta02.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2DIVM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:12:56 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2012 17:12:56 EDT
X-SG: RELAYLIST
X-IronPort-AV: E=Sophos;i="4.75,395,1330923600"; 
   d="scan'208";a="15179298"
Message-ID: <1334005389.1744.4.camel@frustration.ornl.gov>
Subject: Re: [PATCH 04/26] typhoon: get rid of redundant conditional before
 all to release_firmware()
From: David Dillow <dave@thedillows.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, netdev@vger.kernel.org
Date: Mon, 09 Apr 2012 17:03:09 -0400
In-Reply-To: <alpine.LNX.2.00.1204092208140.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1204092208140.13925@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 22:50 +0200, Jesper Juhl wrote:
> There's no need to test for a NULL pointer before calling
> release_firmware() since the function does that check itself, so
> remove the redundant test.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

FWIW on a trivial patch,

Acked-by: David Dillow <dave@thedillows.org>
