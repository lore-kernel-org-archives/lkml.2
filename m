Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab1CWObi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:31:38 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40081 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1CWObh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:31:37 -0400
Date: Wed, 23 Mar 2011 15:31:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: "'Stephen Boyd'" <sboyd@codeaurora.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use asm-generic/sizes.h
Message-ID: <20110323143134.GA10136@merkur.ravnborg.org>
References: <1300751462-1494-1-git-send-email-sboyd@codeaurora.org> <201103220934.50435.arnd@arndb.de> <20110322092113.GB17264@n2100.arm.linux.org.uk> <201103221110.20861.arnd@arndb.de> <00ec01cbe897$2eed7210$8cc85630$@mprc.pku.edu.cn> <4D88ECE3.1070209@codeaurora.org> <00fc01cbe8f9$cd807640$688162c0$@mprc.pku.edu.cn> <4D896616.7070307@codeaurora.org> <016301cbe934$957a69f0$c06f3dd0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <016301cbe934$957a69f0$c06f3dd0$@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm hoping that kbuild gets asm-generic support sometime soon so files
> > with only a "#include <asm-generic/*>" are generated instead of living
> > in the tree. In that case I'd rather have the non power of 2 constants
> > added to the generic sizes.h and be done with it. There isn't any strong
> > technical reason to deny power of 2 constants from the generic header,
> > right?
> No.
> I just think that power-of-2 sizes are more generic, not compulsively of course.
> 
> Sam Ravnborg had introduced a patch set to provide generic support for
> architectures that using one-line asm-generic headers.

It almost ready - but my spare time has been spent on sparc lately.
Will try to take alook at it again soon.

	Sam
