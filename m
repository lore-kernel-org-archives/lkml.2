Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab1FURKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:10:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36672 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752269Ab1FURKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:10:03 -0400
Date: Tue, 21 Jun 2011 18:10:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Taylor Hutt <thutt@google.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Olof Johansson <olofj@chromium.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: codecs: Max98095: Fix logging of hardware revision.
Message-ID: <20110621171000.GA26592@opensource.wolfsonmicro.com>
References: <1308596072-17158-1-git-send-email-thutt@chromium.org>
 <20110621002322.GE1905@opensource.wolfsonmicro.com>
 <B2150E1E4418E1438554A300EA5040E40DDEC16D42@ITSVLEX06.it.maxim-ic.internal>
 <20110621011038.GA4322@opensource.wolfsonmicro.com>
 <20110621115547.GD25032@sirena.org.uk>
 <BANLkTinfL8uSdCvrQYPJb1TQH3HSCu=wAPFZv-AcWRw1_jspXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinfL8uSdCvrQYPJb1TQH3HSCu=wAPFZv-AcWRw1_jspXg@mail.gmail.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 07:52:41AM -0700, Taylor Hutt wrote:

> Please let me know if you'd like me to continue splitting this patch into
> two changes.

It won't hurt if you don't need to respin for some other reason, but
it's not 100% essential.
