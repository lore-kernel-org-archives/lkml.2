Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2ECDvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 23:51:52 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:49018 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2ECDvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 23:51:51 -0400
X-Greylist: delayed 1434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 23:51:51 EDT
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
From: Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20120410234527.GA1401@p4.domain>
Date: Wed, 2 May 2012 23:27:58 -0400
Cc: linux-kernel@vger.kernel.org, jcm@jonmasters.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DEAA41EB-6F96-4C87-BD87-94F9C25A07AF@jonmasters.org>
References: <20120410234527.GA1401@p4.domain>
To: Luming Yu <luming.yu@gmail.com>
X-Mailer: Apple Mail (2.1257)
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [RFC PATCH] a simple hardware detector for lattency as well as throughput
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 10, 2012, at 7:45 PM, Luming Yu wrote:

> The rfc patch reuses some code and idea from jcm's hwlat_detector but
> target for a broader problem that sometime we need to run a simple few minutes
> hardware test to understand if there is any hardware latency as well as
> throughput problem exposed on bare metal or left behind by BIOS or
> interfered by SMI.

Hey thanks. This is totally something I hoped would eventually go upstream,
but I never got around to cleaning it up enough for mass consumption beyond
the use case we had in mind (beating certain folks over the head when they
have "value add" in BIOS code that causes huge SMIs, and the like, for RT).

Did anyone ever get back to you on this one? I never saw any followup. I
will be happy to do some testing and help you get this mainlined.

Jon.

