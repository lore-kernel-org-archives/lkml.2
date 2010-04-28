Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0D1VRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:17:15 -0400
Received: from lechat.rtp-net.org ([88.191.19.38]:55808 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab0D1VRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:17:14 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Apr 2010 17:17:14 EDT
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-fbdev@vger.kernel.org, ralf@linux-mips.org, jayakumar.lkml@gmail.com,
       gregkh@suse.de, yuasa@linux-mips.org, lethal@linux-sh.org,
       akpm@linux-foundation.org, adobriyan@gmail.com, support@simtec.co.uk,
       ben@simtec.co.uk, linux@simtec.co.uk, jkosina@suse.cz,
       pjones@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] s3c2410fb: correct sections
References: <1272450305-7284-1-git-send-email-henne@nachtwindheim.de>
	<1272450305-7284-3-git-send-email-henne@nachtwindheim.de>
Organization: RtpNet
Date: Wed, 28 Apr 2010 23:16:51 +0200
In-Reply-To: <1272450305-7284-3-git-send-email-henne@nachtwindheim.de> (Henrik Kretzschmar's message of "Wed\, 28 Apr 2010 12\:25\:04 +0200")
Message-ID: <87och3gtvg.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrik Kretzschmar <henne@nachtwindheim.de> writes:

> Since the drivers probe calls were changed from .init.text
> to .devinit.text in commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b
> all the function from .init.text should be moved to .devinit.text, too.
>
> The drivers remove calls can also be move from .text to .devexit.text.

Build tested and booted on my h1940 with current git head
(1d16b0f2f3edf05f12a9e3960588e0d4854157bb).

Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>
