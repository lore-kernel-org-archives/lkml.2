Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2HaNQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:16:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50685 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2HaNQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:16:14 -0400
Date: Fri, 31 Aug 2012 08:16:06 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Subject: Re: [PATCH 8/9] ARM i.MX53: Add pwms to dtsi
Message-ID: <20120831001604.GG3613@r65073-Latitude-D630>
References: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
 <1346154504-5623-9-git-send-email-s.hauer@pengutronix.de>
 <20120830223219.GF3613@r65073-Latitude-D630>
 <20120831130723.GS26594@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831130723.GS26594@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 03:07:23PM +0200, Sascha Hauer wrote:
> > >  	clk_register_clkdev(clk[ssi1_ipg_gate], NULL, "63fcc000.ssi");
> > >  	clk_register_clkdev(clk[ssi2_ipg_gate], NULL, "50014000.ssi");
> > >  	clk_register_clkdev(clk[ssi3_ipg_gate], NULL, "63fd0000.ssi");
> > > +	clk_register_clkdev(clk[pwm1_ipg_gate], "ipg", "53fb4000.pwm");
> > > +	clk_register_clkdev(clk[pwm1_hf_gate], "per", "53fb4000.pwm");
> > > +	clk_register_clkdev(clk[pwm2_ipg_gate], "ipg", "53fb8000.pwm");
> > > +	clk_register_clkdev(clk[pwm2_hf_gate], "per", "53fb8000.pwm");
> > 
> > It should be in a separate patch?
> 
> Should it? Surely I can do this, I had the feeling though that it
> belongs together.
> 
>From patch subject, I do not expect these changes in the patch.  It's
okay to have it but we need a more proper patch subject then.  

-- 
Regards,
Shawn
