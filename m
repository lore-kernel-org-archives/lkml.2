Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1JJNDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:03:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50364 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1JJNDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:03:35 -0400
Message-ID: <4E92ED1F.9020902@linaro.org>
Date: Mon, 10 Oct 2011 15:03:27 +0200
From: Michael Opdenacker <michael.opdenacker@linaro.org>
Organization: Linaro
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: jarkko.nikula@bitmer.com, lrg@ti.com, perex@perex.cz, tiwai@suse.de,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] omap: sound: fix checkpatch.pl error
References: <1318223228-15671-1-git-send-email-michael.opdenacker@linaro.org> <1318223228-15671-3-git-send-email-michael.opdenacker@linaro.org> <20111010093240.GB3040@opensource.wolfsonmicro.com>
In-Reply-To: <20111010093240.GB3040@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 10/10/2011 11:32 AM, Mark Brown wrote:
> Applied, but please do try to make sure your changelogs resemble those
> for the rest of the subsystem.  Especially for trivial patches it's not
> good to increase the effort required to apply them.
Thanks! I will use "ASoC" in my commit messages if I understand correctly.

I must confess I didn't pay enough attention to the list of recipients,
which I just got from scripts/get_maintainer.pl.

I will be more careful next time.

Thanks again,

Michael.

-- 
Michael Opdenacker - Community Manager
Linaro, http://linaro.org
Cell: +33 621 604 642
IRC: 'opm' in #linaro on irc.freenode.net

