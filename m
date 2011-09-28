Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1I1HSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 03:18:47 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:37069 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1I1HSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 03:18:45 -0400
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 28 Sep 2011 17:18:42 +1000
In-Reply-To: <CAOJsxLGt717Mn50xZC5TD2s64A9vt27eAHRRFg+6nbworD4byQ@mail.gmail.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com>
	 <CAOJsxLGt717Mn50xZC5TD2s64A9vt27eAHRRFg+6nbworD4byQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317194324.1998.12.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 10:14 +0300, Pekka Enberg wrote:
> So how do the numbers look like without your patch?

Write is about 110 - 120 MB/s. Read is always below 100 MB/s, mostly
around 50 - 70 MB/s.

PS. The hibernate=nocompress also benefits with the patch. It is all
about avoiding sync reads/writes.

-- 
Bojan

