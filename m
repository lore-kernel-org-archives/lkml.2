Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2ASACl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 19:02:41 -0500
Received: from science.horizon.com ([71.41.210.146]:50401 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753740Ab2ASACk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 19:02:40 -0500
Date: 18 Jan 2012 19:02:38 -0500
Message-ID: <20120119000238.9020.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: djwong@us.ibm.com, linux@horizon.com, rpearson@systemfabricworks.com
Subject: Re: + crc32-move-long-comment-about-crc32-fundamentals-to-documentation.patch added to -mm tree
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120118230133.43D851E004D@wpzn4.hot.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just spotted a trivial typo in this commit.  The original comment says:

- * the divisor (the CRC polynomial) you're dividing by.  Each step of the
- * division, you take one more digit (bit) of the dividend and append it

But the added Documentation/ file has "division," repeated twice:

+Each step of the division, division, you take one more digit (bit) of the

Sorry I missed that earlier.
