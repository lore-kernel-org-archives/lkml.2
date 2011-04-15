Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1DOXWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 19:22:22 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46929 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221Ab1DOXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:22:20 -0400
X-Sasl-enc: pWtLwCuIAArjL45olahHH3hZJuH73EErI9s5PVpLo4bf 1302909740
Date: Fri, 15 Apr 2011 20:22:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [Stable-review] [56/74] x86, microcode, AMD: Extend ucode size
 verification
Message-ID: <20110415232212.GA12829@khazad-dum.debian.net>
References: <20110413155148.974006996@clark.kroah.org>
 <1302752223.5282.674.camel@localhost>
 <20110414074125.GA8575@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414074125.GA8575@aftab>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Borislav Petkov wrote:
> > Good thing nothing important depends on this validation, oh wait...
> 
> Oh wait, please don't tell me that you really think that the CPU relies
> completely on software to do its ucode validation and accepts the "good"
> ucode binary patch blindly...

http://www.securiteam.com/securityreviews/5FP0M1PDFO.html

If it is not a hoax, circa 2004 K8s would accept any crap that passed a
simple checksum test.

I don't trust the claims of strong crypto usage by Intel either,
especially since AFAIK Intel itself never claimed to use anything strong,
just that its microcode was "encrypted".

I sure hope real crypto is used on the more recent cores from both
vendors, though.  Too bad we cannot lock down further microcode updates
until the next hard reset...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
