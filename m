Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1FFKwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:52:41 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57098 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754201Ab1FFKwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:52:40 -0400
Date: Thu, 2 Jun 2011 05:14:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Frank Hofmann <frank.hofmann@tomtom.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/3] PM / Hibernate: Remove arch_prepare_suspend()
Message-ID: <20110602031400.GA1565@ucw.cz>
References: <201105211408.28671.rjw@sisk.pl>
 <201105211410.34491.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105211410.34491.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2011-05-21 14:10:34, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> All architectures supporting hibernation define
> arch_prepare_suspend() as an empty function, so remove it.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
