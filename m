Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2GLAwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:52:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36931 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2GLAwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:52:30 -0400
Message-ID: <4FFDA698.2000707@landley.net>
Date: Wed, 11 Jul 2012 11:15:20 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, rgetz@blackfin.uclinux.org,
        mpm@selenic.com
Subject: feature-removal-schedule entry from 2009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_SAMPLE_RANDOM is 3 years past its sell-by date in
feature-removal-schedule:

What:   IRQF_SAMPLE_RANDOM
Check:  IRQF_SAMPLE_RANDOM
When:   July 2009

Why:    Many of IRQF_SAMPLE_RANDOM users are technically bogus as
        entropy sources in the kernel's current entropy model. To
        resolve this, every input point to the kernel's entropy pool
        needs to better document the type of entropy source it actually
        is. This will be replaced with additional add_*_randomness
        functions in drivers/char/random.c

Who:    Robin Getz <rgetz@blackfin.uclinux.org>
        & Matt Mackall <mpm@selenic.com>

There are 12 remaining uses under drivers/ and 14 more under arch/, the
rest of the hits look like infrastructure implementing it.

Should I run those files through bother-maintainer.pl and try to get
people to stop it, or is there a plan underway I don't know about?

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
