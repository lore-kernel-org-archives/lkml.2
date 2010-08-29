Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0H2NRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:17:36 -0400
Received: from freeflow.nu ([178.79.134.28]:51847 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0H2NRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:17:35 -0400
Message-ID: <4C7A5DDE.8030106@kernel.org>
Date: Sun, 29 Aug 2010 16:17:18 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mikael Abrahamsson <swmike@swm.pp.se>
CC: Stan Hoeppner <stan@hardwarefreak.com>, Christoph Lameter <cl@linux.com>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: 2.6.34.1 page allocation failure
References: <4C70BFF3.8030507@hardwarefreak.com> <alpine.DEB.1.10.1008220842400.8562@uplift.swm.pp.se> <AANLkTin48SJ58HvFqjrOnQBMqLcbECtqXokweV00dNgv@mail.gmail.com> <alpine.DEB.2.00.1008221734410.21916@router.home> <4C724141.8060000@kernel.org> <4C72F7C6.3020109@hardwarefreak.com> <4C74097A.5020504@kernel.org> <alpine.DEB.1.10.1008242114120.8562@uplift.swm.pp.se> <4C7A3B1D.7050500@kernel.org> <alpine.DEB.1.10.1008291433420.8562@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.1.10.1008291433420.8562@uplift.swm.pp.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On Sun, 29 Aug 2010, Pekka Enberg wrote:
>> Do you see these out-of-memory problems with 2.6.35?
On 29.8.2010 15.38, Mikael Abrahamsson wrote:
> Haven't tried it.
>
> Has there been substantial work done there that changes things so that 
> if I reproduce it on 2.6.35, someone will look into the issue in 
> earnest? Since I'll most likely have to compile a new kernel, are 
> there any debug options I should enable to give more information to 
> aid fault finding?
There aren't any debug options that need to be enabled. The reason I'm 
asking is because we had a bunch of similar issues being reported 
earlier that got fixed and it's been calm for a while. That's why it 
would be interesting to know if 2.6.35 or 2.6.36-rc2 (if it's not too 
unstable to test) fixes things.

             Pekka
