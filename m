Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab2HQRRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:17:23 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:58946 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab2HQRRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:17:15 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As2WAHR7LlBV5qoUPGdsb2JhbABFijuvCwF1GQEBAQEeGQ0ngiABAQQBOhwTAQ8FCwgDRhQlChoTiAcKuk4UineCYYM6YAOVToVsjQk
X-IronPort-AV: E=Sophos;i="4.77,786,1336341600"; 
   d="scan'208";a="98910586"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 17 Aug 2012 19:21:30 +0200
To: Daniel J Blueman <daniel@quora.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Add device ID for Bluetooth on Macbook Pro 2012
Message-ID: <20120817172130.GA940@polaris.bitmath.org>
References: <1345182286-21776-1-git-send-email-daniel@quora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345182286-21776-1-git-send-email-daniel@quora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Add the device ID for supporting the Macbook Pro 2012 'MacBookPro10,1'.
> The bluetooth device presents itself as:
> 
> T:  Bus=02 Lev=04 Prnt=04 Port=02 Cnt=03 Dev#=  8 Spd=12  MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=05ac ProdID=8286 Rev=00.86
> S:  Manufacturer=Apple Inc.
> S:  Product=Bluetooth USB Host Controller
> C:  #Ifs= 4 Cfg#= 1 Atr=e0 MxPwr=0mA
> I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=01 Prot=01 Driver=(none)
> I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=(none)
> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> I:  If#= 3 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=01 Driver=(none)
> 
> Patch originally written and tested by clipcarl (forums.opensuse.org).
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---

I did not sign off this patch. The author is different, the subject
and wording is different, the credits are different. It looks like you
sent a patch which I subsequently added my SOB to, but that is not the
case. Please do not do that.

If you meant to add your blessing somehow, or if you are the unknown
original author, adding an originally-by or tested-by or reviewed-by
would be more appropriate.

Either way, the patch is moot; With Gustavo's commit d81a5d195, the
plan is to support this machine via a more generic device entry.

Thanks.
Henrik

