Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2HTUrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:47:49 -0400
Received: from antcom.de ([188.40.178.216]:35927 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab2HTUrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:47:36 -0400
Message-ID: <5032A261.8060702@antcom.de>
Date: Mon, 20 Aug 2012 22:47:29 +0200
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

On 20/08/12 19:55, Wolfram Sang wrote:
>> I've never had my hands on a PNX4008 chip at NXP, but I do
>> believe they are the same IP. That specific I2C IP was used in a
>> number of NXP/Phillips chips besides the PNX4008/LPC32xx. I don't
>> think there are any PNX4008's in the wild, and even working in
>> NXP, I can't find any non-marketing reference material for that
>> part (including the user manual).
> 
> Thanks for the heads up. I'll apply both patches, then.
> 
> Roland, this looks like 3.6-material?

Yes, all bugfixes.

Thanks,

Roland
