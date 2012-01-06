Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030529Ab2AFUbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:31:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44394 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932638Ab2AFUbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:31:33 -0500
Date: Fri, 6 Jan 2012 12:31:21 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Frank Mandarino <fmandarino@endrelia.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Russell King <linux@arm.linux.org.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Public ridicule due to sound/soc/soc-core.c abuse of the driver
 model
Message-ID: <20120106203117.GG2893@opensource.wolfsonmicro.com>
References: <20120106194052.GA7781@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106194052.GA7781@kroah.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 11:40:52AM -0800, Greg KH wrote:

> static void rtd_release(struct device *dev) {}

Oh, great - didn't notice this one.  Liam, this is from the
multi-component stuff and does need sorting.
