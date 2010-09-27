Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab0I0QHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:07:34 -0400
Received: from smtp.kponet.fi ([213.145.209.38]:35387 "EHLO kusti5.kpo.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932912Ab0I0QHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:07:33 -0400
Date: Mon, 27 Sep 2010 19:07:31 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Sami Farin <hvtaifwkbgefbaei@gmail.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net
Subject: Re: Linux 2.6.35.6/e1000e does not receive replies from DHCP server,
 2.6.33 works
Message-ID: <20100927160731.ehcljyewa5b5wrbm@m.safari.iki.fi>
Mail-Followup-To: Sami Farin <safari-kernel@safari.iki.fi>,
	Sami Farin <hvtaifwkbgefbaei@gmail.com>,
	linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
References: <20100927131935.d5f2ghpfaufiq6yx@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927131935.d5f2ghpfaufiq6yx@m.safari.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

False alarm, 2.6.35.6+latest git e1000e does not work any better.
I was just lucky.

One thing what was common, when it works, I get this line a little time
before dhclient start working:

eth0: IPv6 duplicate address fe80::219:d1ff:fe00:5f01 detected!

-- 
Do what you love because life is too short for anything else.

