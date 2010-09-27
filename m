Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab0I0R4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:56:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44396 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab0I0R4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EXGM2j+nQdQRLx5j66wGS/tzo2uxVDVznnEIhjL9IHX1ZVrT6ouCx1YuzLoFmO3W6F
         NdcMG1+4mdP+HA+rU7NpvzDi5YohANvBT8Snxz/WLhu0TV2LpEH7D+4sKD9BwWpKM+3k
         rLHnej9TpcqSMqyFckfC1Qpow8kZQqwoeQOiA=
MIME-Version: 1.0
In-Reply-To: <s5htylbxn6b.wl%tiwai@suse.de>
References: <Pine.LNX.4.64.1009150615510.4515@boston.corp.fedex.com>
	<s5htylbxn6b.wl%tiwai@suse.de>
Date: Tue, 28 Sep 2010 01:56:44 +0800
Message-ID: <AANLkTimXBLM8POjeU6gET7twhV3SVxN0cS99ehLwf7DT@mail.gmail.com>
Subject: Re: Microphone not working on PCI ID 8086:3b56
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        alsa-announce@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:42 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 15 Sep 2010 06:32:22 +0800 (SGT),
> Did you try to play with model option for snd-hda-intel driver?
> For example, model=lenovo-x200 ?

Didn't know there's such option. But I'll try it now. Is there an
option to if the driver is not compiled as a module?

Thanks,
Jeff
