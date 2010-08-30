Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0H3QGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:06:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:52819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab0H3QGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:06:07 -0400
Message-ID: <4C7BD6CB.2060705@kernel.org>
Date: Mon, 30 Aug 2010 18:05:31 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeffrey Carlyle <jeff.carlyle@motorola.com>
CC: OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        linux-kernel@vger.kernel.org, Hu Tao <taohu@motorola.com>,
        jaxboe@fusionio.com, torvalds@osdl.org
Subject: Re: [PATCH v3] scatterlist: prevent invalid free when alloc fails
References: <20100830154825.E4E2560255F@il93ubuntu.localdomain> <20100830160147.DE515603843@il93ubuntu.localdomain>
In-Reply-To: <20100830160147.DE515603843@il93ubuntu.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 16:05:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 05:58 PM, Jeffrey Carlyle wrote:
> +			/*
> +			 * Adjust entry count so that proper free function is
> +			 * used in sg_kfree.
> +			 */
> +			if(pvr)

I suppose you meant "if (prv)"?

-- 
tejun
