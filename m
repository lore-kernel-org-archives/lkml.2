Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0DFN0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:26:32 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:46257 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753734Ab0DFN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:26:26 -0400
Date: Tue, 6 Apr 2010 15:26:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3: Can't insmod after make, because versions now
	differ?!
Message-ID: <20100406132622.GA1366@ucw.cz>
References: <20100405053628.GA12217@elf.ucw.cz> <201004051724.26225.elendil@planet.nl> <20100406070641.GA19231@atrey.karlin.mff.cuni.cz> <201004061500.32569.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004061500.32569.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-04-06 15:00:31, Frans Pop wrote:
> On Tuesday 06 April 2010, Pavel Machek wrote:
> > Yes, but... should module version checking be fixed so that it does
> > not interfere like that?
> 
> I don't think so. Essentially you are getting what you configured: an 
> extremely fine-grained kernel version. It's up to you to decide whether 
> the benefits of that outweigh the limitations it brings.

Yes, I want descriptive version strings. And yes, I'd like to use
modules, and do development.

Unfortunately, these two seem mutually exclusive. Given that Linus
made noises (iirc) about 'everyone should set localversion_auto'... 

> Stripping parts of the kernel version for module compatibility checks could 
> interfere with suffixes explicitly added by distros to specify ABI 
> compatibility.

So split the version into regular parts and very detailed parts,
putting explicit user options into 'regular'?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
