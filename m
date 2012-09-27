Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2I0McH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:32:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49280 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2I0McF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:32:05 -0400
Date: Thu, 27 Sep 2012 14:31:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walter <sahne@0x90.at>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: replace strict_str* with kstrto*
Message-ID: <20120927123156.GA25811@elf.ucw.cz>
References: <20120926201506.GD1244@0x90.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926201506.GD1244@0x90.at>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2012-09-26 22:15:06, Daniel Walter wrote:
> power: replace strict_strtoul with kstrtoul
> 
> Signed-off-by: Daniel Walter <sahne@0x90.at>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
