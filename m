Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0HXTIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:08:40 -0400
Received: from mo-65-41-216-221.sta.embarqhsd.net ([65.41.216.221]:47831 "EHLO
	greer.hardwarefreak.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab0HXTIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:08:37 -0400
Message-ID: <4C7418B3.5060103@hardwarefreak.com>
Date: Tue, 24 Aug 2010 14:08:35 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>, Mikael Abrahamsson <swmike@swm.pp.se>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: 2.6.34.1 page allocation failure
References: <4C70BFF3.8030507@hardwarefreak.com> <alpine.DEB.1.10.1008220842400.8562@uplift.swm.pp.se> <AANLkTin48SJ58HvFqjrOnQBMqLcbECtqXokweV00dNgv@mail.gmail.com> <alpine.DEB.2.00.1008221734410.21916@router.home> <4C724141.8060000@kernel.org> <4C72F7C6.3020109@hardwarefreak.com> <4C74097A.5020504@kernel.org>
In-Reply-To: <4C74097A.5020504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg put forth on 8/24/2010 1:03 PM:

> It looks to me as if tcp_create_openreq_child() is able to cope with the
> situation so the warning could be harmless. If that's the case, we
> should probably stick a __GFP_NOWARN there.

If it would be helpful, here's a complete copy of dmesg:
http://www.hardwarefreak.com/2.6.34.1-dmesg-oopses.txt

Something I forgot to mention earlier is that every now and then I
unmount swap and drop caches to clear things out a bit.  Not sure if
that may be relevant, but since it has to do with memory allocation I
thought I'd mention it.

-- 
Stan
