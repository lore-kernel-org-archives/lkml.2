Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab2F1VTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:19:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58593 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2F1VTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:19:40 -0400
Date: Thu, 28 Jun 2012 22:19:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [PATCH] backlight: add support for disabling backlights via
 sysfs
Message-ID: <20120628211936.GA14286@srcf.ucam.org>
References: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
 <20120628191043.GA9777@srcf.ucam.org>
 <20120628193017.GA29456@thinkpad-t410>
 <20120628193652.GB10945@srcf.ucam.org>
 <20120628211600.GB29456@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628211600.GB29456@thinkpad-t410>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 04:16:00PM -0500, Seth Forshee wrote:

> What I still don't understand is your reason for preferring
> driver-specific interfaces for disabling backlights to a single generic
> interface. Are you afraid that allowing it to be done from userspace
> will make it too easy, and as a result quirks will be applied without
> attempting to fix the problem (i.e. the quriking should go through a
> kernel dev to ensure someone tries to fix the problem is made before
> applying a quirk)?

Yup, that. We'll just end up with three billion forum posts telling 
people to add a line to a text file and nobody will ever fix the real 
problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
