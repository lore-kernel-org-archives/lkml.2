Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0HZG4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 02:56:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39675 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab0HZG4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 02:56:35 -0400
Message-ID: <4C760FEE.1000309@zytor.com>
Date: Wed, 25 Aug 2010 23:55:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>
CC: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
        Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
References: <20100825094925.GA3632@pema> <20100825161214.GA15087@rhlx01.hs-esslingen.de> <20100825211257.GA636@pema> <4C7588FB.4050001@zytor.com> <20100825225036.GV4762@const.famille.thibault.fr> <4C75AFFC.5090601@zytor.com> <20100826064549.GA3353@pema>
In-Reply-To: <20100826064549.GA3353@pema>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 11:45 PM, Sebastien Hinderer wrote:
> Hi,
> 
>> What other forms of enumerable hardware is on this machine?  PCI?
> 
> Yes, just PCI I think.
> 
> Below is the output of lspci -v if that helps.
> 
> Best wishes,
> Shérab.
> 
> 00:00.0 Host bridge: Cyrix Corporation PCI Master
> 	Flags: bus master, medium devsel, latency 0
> 

Good grief ... these clowns didn't even program the subsystem ID?  Could
you verify with lspci -vv -n?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

