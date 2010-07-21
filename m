Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0GUM25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:28:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41271 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751305Ab0GUM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:28:56 -0400
Date: Wed, 21 Jul 2010 13:28:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: Missing config option for SFFSDR_FPGA
Message-ID: <20100721122853.GA15462@rakim.wolfsonmicro.main>
References: <86tynthzja.fsf@peer.zerties.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tynthzja.fsf@peer.zerties.org>
X-Cookie: Who was that masked man?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:58:33PM +0200, Christian Dietrich wrote:

>         As part of the VAMOS[0] research project at the University of
> Erlangen we are looking at multiple integrity errors in linux'
> configuration system.

As I keep saying every time someone reports this problem you really need
to speak to the people responsible for the platform.  This is an issue
specific to the relevant board, please contact the maintainers of the
specific system.

If you're going to do this sort of work you need to watch out for
embedded devices - you will need to make sure to contact the people
responsible for the device as well as the subsystem maintainers who
will often have no specific knowledge of the individual systems.
