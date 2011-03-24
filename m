Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431Ab1CXKVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 06:21:22 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36143 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762Ab1CXKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 06:21:21 -0400
X-Sasl-enc: IbaJmYNSs84BPGAKa3SZzqmzIBGzMyeud9nY5FsMmymu 1300962079
Date: Thu, 24 Mar 2011 07:21:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
Message-ID: <20110324102116.GA17446@khazad-dum.debian.net>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103240336590.4529@x980>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Len Brown wrote:
> +What:	CONFIG_APM
> +When:	2.6.40
> +Why:	Microsoft deleted APM from Windows as of Vista in in 2006.
> +	It now seems more than safe that the latest Linux Kernel be APM-free.
> +	The vintage laptops supporting APM are now difficult to find,
> +	making it problatic to maintain this code.
> +Who:	Len Brown <len.brown@intel.com>

People with a ThinkPad T23, T30 will really not appreciate this, and it
should not be too difficult to recruit some as testers.

Do you want me to try to recruit testers?  These boxes should still work for
about 5 more years, give or take.  IBM *really* knew how to build stuff back
then...

If no testers show up, then the removal would be well justified.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
