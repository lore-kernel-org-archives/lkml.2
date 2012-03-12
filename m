Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2CLPWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:22:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56209 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2CLPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:22:27 -0400
Date: Mon, 12 Mar 2012 15:22:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120312152224.GA13916@srcf.ucam.org>
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <20120312142126.GA11969@srcf.ucam.org>
 <20120312145701.GA12322@ubuntu-macmini>
 <20120312150717.GA13211@srcf.ucam.org>
 <20120312151852.GB12322@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312151852.GB12322@ubuntu-macmini>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:18:52AM -0500, Seth Forshee wrote:

> Why do you presume it works under Windows? Boot camp installs a pile of
> drivers for Windows, one of those could be a driver for the backlight. I
> don't know either way. But it's pretty clear that MacOS is using the
> gmux for the backlight when it is present from the reverse engineering
> work done by others.

The only reason to provide it at all is for Windows - it's never going 
to be used under OS X.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
