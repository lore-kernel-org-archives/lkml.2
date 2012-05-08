Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab2EHW5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:57:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48930 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929Ab2EHW5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:57:31 -0400
X-Sasl-enc: 4h37SO/bwrOvgo7gDXbUV8LZXN9d5sg+Bc3zz326/9Yi 1336517850
Date: Tue, 8 May 2012 15:57:29 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120508225729.GF7948@kroah.com>
References: <1336004953.4240.9.camel@mop>
 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop>
 <CA+1xoqdk_yGQyX+6yHyvHsQ1hXiraOzbhVZAgmLmmtMtVTPeGQ@mail.gmail.com>
 <CAPXgP11882vP5GtMmwdsw-w6-D6q9NXHNsHem3Ump17__r2xOQ@mail.gmail.com>
 <CAPXgP11G9Tv37qTy_kLcYphosUXc+2uQDzU6BYekGdVt3Oye4A@mail.gmail.com>
 <CA+1xoqenmuF+K7SAajM5L7zSkKxVKbN7GAdhMJmNjCNW1VQ3Yg@mail.gmail.com>
 <CAPXgP12eWBFcONpYCxHdoED1sy21GYuBdfr46JzgRgXy2EL=+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP12eWBFcONpYCxHdoED1sy21GYuBdfr46JzgRgXy2EL=+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 06:27:42PM +0200, Kay Sievers wrote:
> On Tue, May 8, 2012 at 5:57 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> > What about PRINTK_TIME? Are there plans to enable it on console output?
> 
> Yeah, we should restore the old behaviour. The timestamp is always
> stored internally, regardless of the CONFIG_PRINTK_TIME or tunable
> setting. At the moment, seems they are only (conditionally) added to
> the syslog() output and (unconditionally) to the /dev/kmsg export.
> 
> I guess we just re-define CONFIG_PRINTK_TIME and the tunable as: "show
> time in syslog() and on the console output".

That would be good to put back, can you do that?

thanks,

greg k-h
