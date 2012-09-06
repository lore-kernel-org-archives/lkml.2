Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2IFJnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:43:53 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:39603 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2IFJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:43:51 -0400
Date: Thu, 6 Sep 2012 11:43:48 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re: snd-usb: "delay: estimated 0, actual 352"
Message-ID: <20120906094348.GA257@x4>
References: <s5hmx1526mg.wl%tiwai@suse.de>
 <20120906060220.GA252@x4>
 <504843BA.2040808@gmail.com>
 <s5hehmfir46.wl%tiwai@suse.de>
 <20120906065340.GA257@x4>
 <50484BEB.4020103@gmail.com>
 <20120906071757.GB257@x4>
 <s5h627rioxt.wl%tiwai@suse.de>
 <s5hsjavh88c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hsjavh88c.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.09.06 at 10:21 +0200, Takashi Iwai wrote:
> At Thu, 06 Sep 2012 09:35:26 +0200,
> Takashi Iwai wrote:
> 
> In short, a patch like below may fix the issue (note: completely
> untested!)

No it doesn't, unfortunately...

-- 
Markus
