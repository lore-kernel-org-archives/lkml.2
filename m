Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2FFIOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:14:22 -0400
Received: from smtp206.alice.it ([82.57.200.102]:40118 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab2FFIOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:14:20 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 04:14:19 EDT
Date: Wed, 6 Jun 2012 10:09:00 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Daniel Ribeiro <drwyrm@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFT] regulator: pcap: Convert to
 regulator_list_voltage_table
Message-Id: <20120606100900.42cfef03f2a125b29713a90a@studenti.unina.it>
In-Reply-To: <1338942997.9940.1.camel@phoenix>
References: <1338942997.9940.1.camel@phoenix>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2012 08:36:37 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/pcap-regulator.c |   95 ++++++++++++++++--------------------
>  1 file changed, 42 insertions(+), 53 deletions(-)
>

Patch looks OK to me, but I cannot actually test it until next month or
so, some pieces of the OpenEZX kernel need to be updated to more recent
kernels.

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
