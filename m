Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2K1K5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 05:57:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14882 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2K1K5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 05:57:04 -0500
X-AuditID: cbfee61b-b7f616d00000319b-a4-50b5edfe3512
From: Byungho An <bh74.an@samsung.com>
To: "'Giuseppe CAVALLARO'" <peppe.cavallaro@st.com>
Cc: davem@davemloft.net, jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        kgene.kim@samsung.com, linux-kernel@vger.kernel.org
References: <004b01cdc959$80af8030$820e8090$%an@samsung.com>
 <50B344FC.4070405@st.com>
In-reply-to: <50B344FC.4070405@st.com>
Subject: RE: [PATCH 1/3] net: stmmac: change GMAC control register for SGMII
Date: Wed, 28 Nov 2012 19:57:02 +0900
Message-id: <009401cdcd57$18b275d0$4a176170$%an@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3LwS5UZ6ImkBwLSg2ZFMgL5Zo94QBlR4Dg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ91/b7cGGJxdrG9xedccNotjC8Qc
	mDw+b5ILYIzisklJzcksSy3St0vgynh7/i9rwX+xiuXv37A3MLYLdTFyckgImEhcuvydEcIW
	k7hwbz0biC0ksIxR4tp9RZiaP2tvsHcxcgHFpzNKNHWuYIFwfjFKLJr+nQmkik1ATaJ55mWw
	bhEBQ4k/KxuZQYqYBZoZJSaeBmkHGRshcX/3Z1YQmxOoYe2/jUANHBzCAj4Skz9KgoRZBFQl
	7p9qBSvhFbCROHRwLguELSjxY/I9MJtZQEti/c7jTBC2vMTmNW+ZQcZICKhLPPqrC3GCkcSJ
	163MECUiEvtevGOEGC8g8W3yIRaIclmJTQfArpQQWMUucfNMJzvEw5ISB1fcYJnAKDELyeZZ
	SDbPQrJ5FpIVCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmKERJj0DsZVDRaHGAU4GJV4
	eB0ctwYIsSaWFVfmHmKU4GBWEuFlfgQU4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5Hxg9OeV
	xBsaG5uYmZiamFuampviEFYS5232SAkQEkhPLEnNTk0tSC2CGcfEwSnVwCi1evrVfhXDaa8d
	9hxftGdtWf/Sz3dCXV8VzJmtviFVQy3qyD6dzk7Wn11Filt5DTKaN1cl3nAWD2d9ETH9g/dK
	LUZR/6dCBz/NF+1fdDXu8uNjysv5Jsm7lnl/vLXi7CNO67L846aFs7aLTJxXcypll3BWjnRU
	wZ6V09aqfYypXXD5RIJn0VklluKMREMt5qLiRADExp/+3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd1/b7cGGOzdqmFxedccNotjC8Qc
	mDw+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMAZqspFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8x4e/4va8F/sYrl
	79+wNzC2C3UxcnJICJhI/Fl7gx3CFpO4cG89WxcjF4eQwHRGiabOFSwQzi9GiUXTvzOBVLEJ
	qEk0z7zMBmKLCBhK/FnZyAxSxCzQzCgx8TTEKCGBCIn7uz+zgticQA1r/20EauDgEBbwkZj8
	URIkzCKgKnH/VCtYCa+AjcShg3NZIGxBiR+T74HZzAJaEut3HmeCsOUlNq95ywwyRkJAXeLR
	X12IE4wkTrxuZYYoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yY
	W1yal66XnJ+7iREcwc+kdzCuarA4xCjAwajEw+vguDVAiDWxrLgy9xCjBAezkggv8yOgEG9K
	YmVValF+fFFpTmrxIUYfoEcnMkuJJucDk0teSbyhsYmZkaWRmYWRibk5DmElcd5mj5QAIYH0
	xJLU7NTUgtQimHFMHJxSDYwe3tpi00pnn+SdkTbjV+HtrcWN4mZbhQO+2z2N87Q3nR9iGFFT
	uzyMbfe9aYbTnu49rxkzna3p28f+x9MWHF22NjXhRvua8qPscWZ8i6KUtvw4PyN1YmU1d3H1
	ns3V39ojWldsXnzuhJ8we8W3rXmVVtciDlQVNLOcfa4U+Xvzr+K7m4X+JV5XYinOSDTUYi4q
	TgQALbif1w0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 07:31 PM, Giuseppe CABALLARO wrote:
> On 11/23/2012 10:04 AM, Byungho An wrote:
> >
> > This patch changes GMAC control register (TC(Transmit
> > Configuration) and PS(Port Selection) bit for SGMII.
> > In case of SGMII, TC bit is '1' and PS bit is 0.
> 
> IMO this new support that should be released for net-next and further 
> effort is actually needed.
>
OK, I see but if possible, I want to support the new features which is
included in this patch from v3.8
 
> The availability of the PCS registers is given by looking at the HW 
> feature register. In fact, these are optional registers.
> I don't want to break the compatibility with old chips.
> 
It means that old chip doesn't have this bit or this register? If that, how
about using compatible in DT blob like snps,dwmac-3.70a and then in just
this case trying to read this bit and this register.

> I do not see why we have to use Kconfig macro to select ANE etc (as 
> you do in your patches).
OK. I agree with you.

> The driver could directly manage the phy device by itself if possible 
> and the stmmac_init_phy should be reworked.
> 
Could you explain more detail? As I understood, after set ANE bit in MAC
side then PHY auto-negotiation can be enabled. If I'm wrong let me know.
According to your mention, MAC and PHY auto-negotiation can be managed in
stmmac_init_phy?

> There are several things that need to be implemented. For example:
> 
> The ISR (e.g. priv->hw->mac->host_irq_status) should be able to manage 
> these new interrupts.
I think that there would be two additional interrupts."PCS Auto-Negotiation
Complete" and "PCS Link Status Changed". These two interrupts are added to
"stmmac_interrupt". In my opinion, there are no specific processing for
these two irqs. What do you think about it?

> The code has to be able to maintain the user interface.
> For example if you want to enable ANE or manage Advertisement caps.
> 
Does it mean that command line or other network command(e.g. ifconfig...) or
ioctol? Actually I don't understand exact user interface way. Could you
recommend the method for user interface?

> > Signed-off-by: Byungho An <bh74.an@samsung.com>
> > ---
> 
> [snip]
> 
> > +	if (priv->phydev->interface == PHY_INTERFACE_MODE_SGMII) {
> > +		value = readl(priv->ioaddr);
> > +		/* GMAC_CONTROL_TC : transmit config in RGMII/SGMII */
> > +		value |= 0x1000000;
> > +		/* GMAC_CONTROL_PS : Port Selection for GMII */
> > +		value &= ~(0x8000);
> > +		writel(value, priv->ioaddr);
> > +	}
> > +
> 
> 
> This parts of code have to be moved in 
> drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
> 
OK.

> Pls, do not use value |= 0x1000000 but provide the appropriate defines.
> 
OK.

> >   	/* Request the IRQ lines */
> >   	ret = request_irq(dev->irq, stmmac_interrupt,
> >   			 IRQF_SHARED, dev->name, dev);
> >
Thank you.
Byungho An.


