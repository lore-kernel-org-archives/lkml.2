Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2BQVZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:25:37 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:40084 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936Ab2BQVZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:25:36 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 02/10] lantiq_etop: set addr_assign_type if random_ether_addr() used
Date: Fri, 17 Feb 2012 22:24:35 +0100
User-Agent: KMail/1.9.10
Cc: blogic@openwrt.org, ralf@linux-mips.org, jeffrey.t.kirsher@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de> <1329493411-25750-3-git-send-email-danny.kukawka@bisect.de> <20120217.160006.1000847808550095794.davem@davemloft.net>
In-Reply-To: <20120217.160006.1000847808550095794.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202172224.35902.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329513935;bbb49363;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag, 17. Februar 2012, David Miller wrote:
> From: Danny Kukawka <danny.kukawka@bisect.de>
> Date: Fri, 17 Feb 2012 16:43:23 +0100
>
> > Set addr_assign_type correctly to NET_ADDR_RANDOM in case
> > a random MAC address was generated and assigned to the netdevice.
> >
> > v2: added comment, renamed bool variable to random_mac
> >
> > Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>
> More bad comment formatting.
>
> > +	/*set addr_assign_type here, ltq_etop_set_mac_address would reset it*/
>
> Again, I fixed it up but I will not next time.

Thanks. I fixed it but accidently send the unfixed version of the patches 
without noticing. Sorry.

Danny
