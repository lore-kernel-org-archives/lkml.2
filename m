Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0HYWun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:50:43 -0400
Received: from solo.fdn.fr ([80.67.169.19]:35693 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0HYWuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:50:39 -0400
Date: Thu, 26 Aug 2010 00:50:36 +0200
From: Samuel Thibault <Samuel.Thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>,
        Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100825225036.GV4762@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>,
	Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
References: <20100825094925.GA3632@pema> <20100825161214.GA15087@rhlx01.hs-esslingen.de> <20100825211257.GA636@pema> <4C7588FB.4050001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C7588FB.4050001@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, le Wed 25 Aug 2010 14:19:55 -0700, a écrit :
> At that point I'd almost prefer doing something like a BIOS signature
> check if we can't do anything better.

Well, there will be several versions of the BIOS signature, which the
constructor is not likely to provide.

Just to make sure there's no misunderstanding: it was never planned that
this driver be loaded unless some manual intervention, like explicitly
loadling the module or setting some parameter, so that if bad effects
happen on the machine, the user can only get angry at himself for having
loaded by hand a random module without reading the documentation that
explicitly says (twice) it's only for a particular kind of hardware.

I however now realize that I don't find a way to force a driver to be
compiled only as a module.  If there isn't, I guess we can just add
a module parameter to enable/disable the driver, so that it won't be
active by default even compiled-in?

Samuel
