Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2BCSwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:52:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36125 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757375Ab2BCSwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:52:31 -0500
X-Sasl-enc: 81zsSftPijcmSCrGYCBCpNSRvvbbJHvYTj38SoMuFo0N 1328295121
Date: Fri, 3 Feb 2012 10:51:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: tim.gardner@canonical.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: Linux 3.2.3
Message-ID: <20120203185157.GA2865@kroah.com>
References: <20120203174758.GA18584@kroah.com>
 <4F2C2A40.1080601@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F2C2A40.1080601@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 11:41:04AM -0700, Tim Gardner wrote:
> On 02/03/2012 10:47 AM, Greg KH wrote:
> >I'm announcing the release of the 3.2.3 kernel.
> >
> >All users of the 3.2 kernel series must upgrade.
> >
> >The updated 3.2.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y
> >and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> >
> >thanks,
> >
> >greg k-h
> >
> 
> Build failure in vanilla Linux 3.2.3:
> 
>   CC [M]  sound/soc/codecs/wm5100.o
> sound/soc/codecs/wm5100.c: In function ‘wm5100_set_bias_level’:
> sound/soc/codecs/wm5100.c:1382:33: error: ‘struct wm5100_priv’ has
> no member named ‘regmap’
> sound/soc/codecs/wm5100.c:1398:33: error: ‘struct wm5100_priv’ has
> no member named ‘regmap’
> sound/soc/codecs/wm5100.c:1409:29: error: ‘struct wm5100_priv’ has
> no member named ‘regmap’
> make[5]: *** [sound/soc/codecs/wm5100.o] Error 1
> 
> Looks like it depends on bd132ec585c498ee27d7eedf8569703606743928
> "ASoC: Convert wm5100 to direct regmap API usage", but I haven't
> re-built with it yet.
> 
> See attached config.

Ugh, I didn't have CONFIG_SND_SOC=m in my test config files, I'll go fix
that now and see what needs to be done here, thanks for letting me know.

Mark any hints?

thanks,

greg k-h
