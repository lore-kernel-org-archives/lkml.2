Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab2FTT7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:59:05 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:30187 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754452Ab2FTT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:59:04 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2012 15:59:03 EDT
Date: Wed, 20 Jun 2012 15:49:08 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: Bad rss-counter state
Message-ID: <20120620194908.GA16353@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I just noticed the following couple lines in my kernel log for Linux
3.4.2:

  Jun 20 14:57:54 emergent kernel: BUG: Bad rss-counter state mm:ffff88000ff1f400 idx:1 val:-2
  Jun 20 14:57:54 emergent kernel: BUG: Bad rss-counter state mm:ffff88000ff1f400 idx:2 val:2

I have no idea what these messages mean, nor what I was doing exactly
at 14:57:54 today, nor whether they've been fixed in newer kernels.
Regardless, they appear to be telling me that there's a kernel problem
since they contain the word "BUG", so I figured I had better report them
nonetheless.  Other than the fact that these messages were printed, the
system is operating normally.

This happened about a week after bootup, so it's probably not easy to
reproduce.

Let me know if you need any more info,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

