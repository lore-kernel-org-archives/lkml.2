Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab0LEXrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:47:21 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:48695 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0LEXrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:47:20 -0500
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Dec 2010 18:47:20 EST
Subject: Re: [linux-pm] [PATCH] PM / Hibernate: Restore old swap signature
 to avoid user space breakage
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Karel Zak <kzak@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
In-Reply-To: <201012052324.30231.rjw@sisk.pl>
References: <201012052324.30231.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 10:36:55 +1100
Message-ID: <1291592215.2866.3.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-05 at 23:24 +0100, Rafael J. Wysocki wrote:
> Commit 3624eb0 (PM / Hibernate: Modify signature used to mark swap)
> modified hibernate signature used to mark swap partitions containing
> hibernation images, but that turns out to have caused problems in
> libblkid on recent Ubuntu.  Restore the old signature to avoid those
> problems. 

Don't quite understand this change (sorry, probably just being obtuse).

The signature was changed to make sure older kernels don't handle
compressed images by accident, right? If so, this would seem like a bad
idea, because this is what can actually happen now.

Shouldn't user space learn how to handle both signatures instead?

-- 
Bojan

