Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2AXLmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:42:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57830 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325Ab2AXLmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:42:13 -0500
Date: Tue, 24 Jan 2012 11:42:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: Hang up at .prepare( )
Message-ID: <20120124114210.GB14888@opensource.wolfsonmicro.com>
References: <CANKRQngqJaAq7ucg3VzCMs+-KFXTSuJG=uq4d0kQ95gEMFfB4w@mail.gmail.com>
 <20120124105528.GA20519@opensource.wolfsonmicro.com>
 <CANKRQnibHChSVEOvsDuKTXcnDkx5KQAMOxfheocTJt+ar0CgPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANKRQnibHChSVEOvsDuKTXcnDkx5KQAMOxfheocTJt+ar0CgPw@mail.gmail.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 08:30:17PM +0900, Tomoya MORINAGA wrote:
> 2012/1/24 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> > What efforts have you made to debug this yourself?  Clearly this is not
> > happening for other people, perhaps it is related to something you have
> > in your drivers - have you addressed the issues raised with them?

> I said previously, "our ASoC drivers" not others.
> Of course, I understand current upstreamed drivers don't have this issue.
> I just asked "If someone faced the same issue when debugging, let me
> know about it."

That's not answering my question - I'm asking you what steps you've
taken to progress, to explain the analysis you've done so far.  For
example, what is the blocked thread blocked on - what is it waiting for
and why has that thing happened?

If you have not addressed the review issues with your driver then take a
look at those, perhaps the problem has already been identified through
code review.
