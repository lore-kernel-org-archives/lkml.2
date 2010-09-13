Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0IMQM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:12:57 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4630 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191Ab0IMQM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:12:57 -0400
X-IronPort-AV: E=Sophos;i="4.56,359,1280700000"; 
   d="scan'208";a="59200387"
Date: Mon, 13 Sep 2010 18:12:55 +0200
From: Samuel Thibault <Samuel.Thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Valdis.Kletnieks@vt.edu,
        =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>,
        Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100913161255.GE5364@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
	=?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>,
	Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Andres Salomon <dilinger@queued.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20100825094925.GA3632@pema> <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain> <20100826210815.GA18131@pema> <4C76D9A0.2010907@zytor.com> <20100829205929.GA3309@pema> <20100913100719.GA3903@pema> <54870.1284390647@localhost> <20100913152249.GC5364@const.bordeaux.inria.fr> <4C8E4C0D.6010502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C8E4C0D.6010502@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, le Mon 13 Sep 2010 09:06:37 -0700, a écrit :
> On 09/13/2010 08:22 AM, Samuel Thibault wrote:
> > Again, I'm not sure we really should try hard to make it automatically
> > detected (and thus always enabled).  Having to pass a kernel parameter
> > to enable the functionality is completely fine, since installing Linux
> > on this device requires quite some tinkering already.
> > 
> 
> Could you describe this kind of tinkering?

Basically, opening the device to select boot on the external
CompactFlash reader.

Samuel
