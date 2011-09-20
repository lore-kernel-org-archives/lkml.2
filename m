Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1ITRsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:48:08 -0400
Received: from netgear.net.ru ([195.178.208.66]:39948 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750892Ab1ITRsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:48:07 -0400
Date: Tue, 20 Sep 2011 21:47:57 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: rikmorgandev@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: POHMELFS is back
Message-ID: <20110920174757.GA1330@ioremap.net>
References: <20110919061302.GA19699@ioremap.net>
 <4E78C7CD.3030401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E78C7CD.3030401@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 11:05:17AM -0600, Rick Morgan (rikmorgan@gmail.com) wrote:
> <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

Please do not use inline html

>   <pre wrap="">+static inline int dnet_id_cmp_str(const unsigned char *id1, const unsigned char *id2)
> +{
> +	unsigned int <b>i = 0</b>;
> +
> +	for (<b>i*=sizeof</b>(unsigned long); i&lt;DNET_ID_SIZE; ++i) {
> +		if (id1[i] &lt; id2[i])
> +			return -1;
> +		if (id1[i] &gt; id2[i])
> +			return 1;
> +	}
> +
> +	return 0;
> +}
>   </pre>
> </blockquote>
> if i is initialized to 0, wouldn't i*=sizeof(unsigned long) be zero?<br>

Yes, it counts from zero. This chunk previously checked another
parameter first, but since then it was removed, but checking loop
remained.

-- 
	Evgeniy Polyakov
