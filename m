Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1KUW3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:29:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50534 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab1KUW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:29:49 -0500
Date: Mon, 21 Nov 2011 16:29:45 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-wmi: Change debug statements from pr_info to
 pr_debug
Message-ID: <20111121222945.GA14306@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1321908536-5163-1-git-send-email-seth.forshee@canonical.com>
 <20111121205230.GA14467@srcf.ucam.org>
 <20111121211438.GH6736@thinkpad-t410>
 <20111121211809.GA14950@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121211809.GA14950@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 09:18:09PM +0000, Matthew Garrett wrote:
> On Mon, Nov 21, 2011 at 03:14:38PM -0600, Seth Forshee wrote:
> > On Mon, Nov 21, 2011 at 08:52:30PM +0000, Matthew Garrett wrote:
> > > They're intended to be there, in the same way that the keyboard code 
> > > generates unknown scancode errors. We want to know when users have keys 
> > > that don't work.
> > 
> > All right, but what about the unknown WMI events? Those are the bigger
> > problem anyway, as at least one machine (the Latitude XT2) can generate
> > a lot of these messages for unknown reasons. It doesn't appear that
> > anyone has been making use of these messages since we still only support
> > one event. Would you object to demoting that one?
> 
> Those can probably be ignored, but again it would be nice to find out 
> what they actually mean so we know whether we can do anything with them. 
> Any chance of you being able to work with Dell on that?

I'll see what I can do.
