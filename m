Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751Ab1KJQa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:30:56 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:45422 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935188Ab1KJQaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:30:55 -0500
Date: Thu, 10 Nov 2011 17:30:51 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111110163051.GA24533@nomi.cz>
References: <20111029171554.GA16596@nomi.cz> <20111031160342.GB2225@redhat.com> <20111109155411.GA1669@nomi.cz> <20111109165158.GA2254@redhat.com> <20111110091816.GA2247@nomi.cz> <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz> <20111110160703.GA2775@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110160703.GA2775@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 10, 2011 at 05:07:04PM +0100, Stanislaw Gruszka wrote:
> > (We've got a lot of Lenovos here, mostly T520 and T420s, most of them running
> > Fedora, and nobody has reported memory corruption problems.
> 
> Are there any others with 6205? If not that would confirm issue is
> related with that model.

I think all those T520 and T420s models have exactly the same wireless card. I
don't see why they wouldn't have. :-)

> You may first try some older kernel as Wey suggested, i.e. 2.6.38.

Okay, I'll try that as soon as I get some more free time.

Thanks for the suggestions,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
