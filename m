Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab2EAAcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:32:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56257 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab2EAAcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:32:02 -0400
Date: Tue, 1 May 2012 01:31:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Shea Levy <shea@shealevy.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] efi: Validate UEFI boot variables
Message-ID: <20120501003156.GA9543@srcf.ucam.org>
References: <1335816690-26019-1-git-send-email-mjg@redhat.com>
 <1335816690-26019-2-git-send-email-mjg@redhat.com>
 <4F9F279E.606@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9F279E.606@shealevy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 08:00:30PM -0400, Shea Levy wrote:
> On 04/30/2012 04:11 PM, Matthew Garrett wrote:
> >A common flaw in UEFI systems is a refusal to POST triggered by a malformed
> >boot variable. Once in this state, machines may only be restored by
> >reflashing their firmware with an external hardware device. While this is
> >obviously a firmware bug, the serious nature of the outcome suggests that
> >operating systems should filter their variable writes in order to prevent
> >a malicious user from rendering the machine unusable.
> 
> Any chance this will make it safe to use efibootmgr on Apple EFI
> firmware? I've been afraid to use it because I've read it can
> silently brick the device due to a mistake in efibootmgr. Obviously
> this won't correct that mistake, but with this applied should a
> successful variable set imply that the firmware wasn't bricked?

As far as I know that's been fixed since 
202f9d0a41809e3424af5f61489b48b622824aed - the problem wasn't 
efibootmgr, the problem was Apple's firmware overwriting itself.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
