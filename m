Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2F1VQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 17:16:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35362 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2F1VQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 17:16:06 -0400
Date: Thu, 28 Jun 2012 16:16:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [PATCH] backlight: add support for disabling backlights via sysfs
Message-ID: <20120628211600.GB29456@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	Corentin Chary <corentin.chary@gmail.com>
References: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
 <20120628191043.GA9777@srcf.ucam.org>
 <20120628193017.GA29456@thinkpad-t410>
 <20120628193652.GB10945@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628193652.GB10945@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 08:36:52PM +0100, Matthew Garrett wrote:
> Userspace should already be prioritising platform interfaces over raw 
> interfaces, so if gmux works on the Mac then there's no problem. DMI 
> lists should, broadly speaking, be unnecessary - they're mostly a 
> symptom of us not understanding how the hardware is expected to work.

I agree that we want to avoid papering over problems instead of fixing
them, but we're already disabling the ACPI backlight in some cases and
will continue to do so for the time being. We're also doing it with
apple_bl. It's not a question of whether we do it, but how.

What I still don't understand is your reason for preferring
driver-specific interfaces for disabling backlights to a single generic
interface. Are you afraid that allowing it to be done from userspace
will make it too easy, and as a result quirks will be applied without
attempting to fix the problem (i.e. the quriking should go through a
kernel dev to ensure someone tries to fix the problem is made before
applying a quirk)?

