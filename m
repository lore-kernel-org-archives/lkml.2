Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0HZAT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 20:19:29 -0400
Received: from solo.fdn.fr ([80.67.169.19]:48981 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab0HZAT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 20:19:27 -0400
Date: Thu, 26 Aug 2010 02:19:24 +0200
From: Samuel Thibault <Samuel.Thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>,
        Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100826001924.GE4762@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>,
	Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
References: <20100825094925.GA3632@pema> <20100825161214.GA15087@rhlx01.hs-esslingen.de> <20100825211257.GA636@pema> <4C7588FB.4050001@zytor.com> <20100825225036.GV4762@const.famille.thibault.fr> <4C75AFFC.5090601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C75AFFC.5090601@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, le Wed 25 Aug 2010 17:06:20 -0700, a écrit :
> On 08/25/2010 03:50 PM, Samuel Thibault wrote:
> > H. Peter Anvin, le Wed 25 Aug 2010 14:19:55 -0700, a écrit :
> >> At that point I'd almost prefer doing something like a BIOS signature
> >> check if we can't do anything better.
> > 
> > Well, there will be several versions of the BIOS signature, which the
> > constructor is not likely to provide.
> 
> Then we'll gather them up, or something.

Who?  This is a very particular kind of device, on which you can install
Linux only through some trick, thus machine coverage will most probably
be very low.  Having to activate a module by hand is really not a
problem here.

> What other forms of enumerable hardware is on this machine?  PCI?

I don't remember and will let Shérab answer.

Samuel
