Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1COWjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:39:20 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49078 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754114Ab1COWjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:39:16 -0400
Date: Tue, 15 Mar 2011 23:37:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: matthieu castet <castet.matthieu@free.fr>
Cc: x86@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] v2 merge 32 and 64 realmode wakeup code
Message-ID: <20110315223753.GA1700@atrey.karlin.mff.cuni.cz>
References: <4D7FE5C5.3040106@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7FE5C5.3040106@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - this mean less ifdef in code
> - we could remove now unused field in wakeup_header (pmode_*)
>
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
