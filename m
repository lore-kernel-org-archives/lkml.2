Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2ICUQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 16:16:28 -0400
Received: from antcom.de ([188.40.178.216]:41932 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab2ICUQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 16:16:26 -0400
Message-ID: <50451016.7010608@antcom.de>
Date: Mon, 03 Sep 2012 22:16:22 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Kevin Wells <kevin.wells@nxp.com>,
        "vitalywool@gmail.com" <vitalywool@gmail.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Bakki <srinivas.bakki@nxp.com>,
        "aletes.xgr@gmail.com" <aletes.xgr@gmail.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Subject: Re: [PATCH RESEND 1/2] i2c: pnx: Fix bit definitions
References: <1344411752-23469-1-git-send-email-stigge@antcom.de> <20120818095108.GB24812@pengutronix.de> <5030A81E.5090508@antcom.de> <083DF309106F364B939360100EC290F823A0354A3D@eu1rdcrdc1wx030.exi.nxp.com> <20120820175527.GA9169@pengutronix.de>
In-Reply-To: <20120820175527.GA9169@pengutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On 20/08/12 19:55, Wolfram Sang wrote:
>> I've never had my hands on a PNX4008 chip at NXP, but I do
>> believe they are the same IP. That specific I2C IP was used in a
>> number of NXP/Phillips chips besides the PNX4008/LPC32xx. I don't
>> think there are any PNX4008's in the wild, and even working in
>> NXP, I can't find any non-marketing reference material for that
>> part (including the user manual).
> 
> Thanks for the heads up. I'll apply both patches, then.

Should I consider the two patches as applied now (where?
i2c-embedded?), or should I resend? ;-)

Thanks in advance,

Roland
