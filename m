Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0DIRi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 13:38:27 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:18488
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab0DIRiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:38:25 -0400
X-Trace: 197996783/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAOECv0tTQwwf/2dsb2JhbACbO3K8C4UJBA
X-IronPort-AV: E=Sophos;i="4.52,179,1270422000"; 
   d="scan'208";a="197996783"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: Ooops when working with USB MIDI (2.6.33.1)
Date: Fri, 9 Apr 2010 18:36:50 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
References: <201004051433.47171.tvrtko@ursulin.net> <201004090751.35398.tvrtko@ursulin.net> <s5hfx35ccde.wl%tiwai@suse.de>
In-Reply-To: <s5hfx35ccde.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004091836.51023.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 Apr 2010 08:29:33 Takashi Iwai wrote:
> At Fri, 9 Apr 2010 07:51:35 +0100,
> 
> Tvrtko Ursulin wrote:
> > On Thursday 08 Apr 2010 13:22:36 Takashi Iwai wrote:
> > > > Takashi, do you remember what the original problem was?
> > >
> > > Well, I have only a vague memory -- it's a similar scenario that some
> > > app still accessing after disconnection.  The URB can't be handled
> > > after the disconnection is finished.
> > >
> > > I think the patch below might fix in this case.  You can try it
> > > instead of reverting the commit above.

A very quick test and it looks good  - did not crash in the disconnect and 
then exit TuxGuitar scenario. Thank you!

Tvrtko
