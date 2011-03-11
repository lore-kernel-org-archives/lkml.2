Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1CKNjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:39:07 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37308 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750735Ab1CKNjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:39:02 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19xi0kKJcFxpxqdI9T65/inmsSKimSx3YsEUH8Eat
	F4d1fa1kSO89Rk
Date: Fri, 11 Mar 2011 14:38:52 +0100
From: torbenh <torbenh@gmx.de>
To: Christian Riesch <christian.riesch@omicron.at>
Cc: Richard Cochran <richardcochran@gmail.com>,
        john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
Message-ID: <20110311133852.GB5553@siel.b>
Mail-Followup-To: Christian Riesch <christian.riesch@omicron.at>,
	Richard Cochran <richardcochran@gmail.com>,
	john stultz <johnstul@us.ibm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Richard Cochran <richard.cochran@omicron.at>,
	"tglx@linutronix.de" <tglx@linutronix.de>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-3-git-send-email-torbenh@gmx.de>
 <1299180844.28285.111.camel@work-vm>
 <20110304064639.GD3824@riccoc20.at.omicron.at>
 <1299355687.28285.130.camel@work-vm>
 <20110306132834.GA11790@riccoc20.at.omicron.at>
 <20110311111321.GA5553@siel.b>
 <95DC1AA8EC908B48939B72CF375AA5E3011C9E20A4@alice.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95DC1AA8EC908B48939B72CF375AA5E3011C9E20A4@alice.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 12:37:57PM +0100, Christian Riesch wrote:
> Torben,
> 
> On Friday, March 11, 2011 12:13, torbenh wrote:
> >On the audio lists, we have a guy now claiming that software ptp would
> >confuse the whole h/w ptp infrastructure. His main agenda seems to be to
> >prevent a software only ptp/avb implementatation.
> 
> could you please post a link to that discussion?

duncan started somewhat like this:
http://article.gmane.org/gmane.comp.audio.jackit/23606
http://article.gmane.org/gmane.comp.audio.jackit/23612

then it seems that he somehow turned his head:
http://www.mail-archive.com/linux-audio-dev@lists.linuxaudio.org/msg11765.html

maybe we have a communication problem, with the definition of "play"
i only want to be able to generate an RTP stream on my computer.

the actual conversion from packets to analog signal would be happening on a
networked soundcard. the goal is to achieve low latency in the range of
2-3ms ...

maybe he interprets playing the rtp stream, as converting the rtp
packets to analog audio.
this obviously wouldnt work with software ptp, because we would need
nanoseconds accuracy of the clock.

but to just create an rtp stream, where a 2ms buffer doesnt underflow,
just requires a clock accuracy of 500us.

all in all this discussion might be a bit confusing.


> Thanks,
> Christian

-- 
torben Hohn
