Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab1CRVL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:11:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab1CRVLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:11:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: andy.green@linaro.org
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 18 Mar 2011 22:11:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Anders <x0132446@ti.com>, Greg KH <greg@kroah.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <4D83A25C.804@ti.com> <20110318182518.GA2271@opensource.wolfsonmicro.com> <4D83BA4F.8050301@linaro.org>
In-Reply-To: <4D83BA4F.8050301@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103182211.36869.arnd@arndb.de>
X-Provags-ID: V02:K0:Xa49IBPbOhWBHt/potWwn1SDBGDkZlkPkOr4yG3mJw6
 tX/Xlo7O+875GcSVKVM0xWsYXvuJt8U/daC9HslyNk8sxXI21R
 /7LbYXZuHZnxAPCZXfvcTtF5vMY+vqmfeJjtma3n2wZvvpgtkh
 PfoZKJ3r1lF+4RSzSyzt2QvFegdh23lKIXr4feSeY8OTnFccSN
 bhEa4oIRSS9sSlMtPq3qA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Andy Green wrote:
> In which case, they are all potential consumers of a MAC "stored in an 
> alternative location and needs to be programmed into the NIC by 
> software" solution, which he also thinks is needed.

Note that there is also of_get_mac_address(), which is meant to
deal with this exact problem.

	Arnd
