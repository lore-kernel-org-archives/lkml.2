Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab0GaFD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 01:03:28 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:38632 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0GaFD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 01:03:27 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1280551286.3097.6.camel@shrek.rexursive.com>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <1280486667.2608.1.camel@shrek.rexursive.com>
	 <4C534C9D.8000600@tuxonice.net>
	 <1280532174.2583.1.camel@shrek.rexursive.com>
	 <4C5362E7.3000706@tuxonice.net>
	 <1280538184.2583.11.camel@shrek.rexursive.com>
	 <4C537A01.5040808@tuxonice.net>
	 <1280540035.2658.5.camel@shrek.rexursive.com>
	 <1280551286.3097.6.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 15:03:25 +1000
Message-ID: <1280552605.3080.1.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-31 at 14:41 +1000, Bojan Smojver wrote:
> I did 3 hibernate/thaw cycles with it. Images varied from about 850
> MB, 1.1 GB to 750 MB. I was getting 156/141 MB/s, 121/118 MBs and
> 141/130 MBs speeds. Obviously, these things depend on compression
> ratios achieved etc. 

For the record, my machine usually does around 32 MB/s on hibernate and
54 MB/s on thaw with regular in-kernel swsusp.

-- 
Bojan

