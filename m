Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0JMNFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:05:45 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52219 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752286Ab0JMNFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:05:44 -0400
Date: Wed, 13 Oct 2010 09:10:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/2] move TI_ST driver out of staging
Message-ID: <20101013071038.GB1610@ucw.cz>
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> As suggested, I've squashed the 4 patches into a set of 2 patches.
> 1. moves the source files.
> 2. moves/modifies the Kconfig and Makefiles.
> 

>  drivers/misc/ti-st/st_kim.c     |  798 ++++++++++++++++++++++++++++++
>  drivers/misc/ti-st/st_ll.c      |  150 ++++++


Is-it_really-neccessary_to-mix '-' and '_' in the name? Perhaps
directory could be named just 'tist'?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
