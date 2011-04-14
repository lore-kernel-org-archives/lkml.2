Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab1DNJ1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:27:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32785 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab1DNJ1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:27:19 -0400
From: "Nori, Sekhar" <nsekhar@ti.com>
To: Mike Williamson <michael.williamson@criticallink.com>
CC: Ben Gardiner <bengardiner@nanometrics.ca>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        Philby John <pjohn@in.mvista.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 14 Apr 2011 14:56:38 +0530
Subject: RE: [PATCH 6/6] da8xx: enable the use of the ICPFUNC in i2c-davinci
Thread-Topic: [PATCH 6/6] da8xx: enable the use of the ICPFUNC in i2c-davinci
Thread-Index: Acv6Ly5Z/PZpOO+7R+C6Ohbe9KrF4wATkFKA
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C960196@dbde02.ent.ti.com>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
 <f1ff3f2888725a1e03541e0be5c0880f0591aea2.1302031487.git.bengardiner@nanometrics.ca>
 <B85A65D85D7EB246BE421B3FB0FBB593024C8B3C9F@dbde02.ent.ti.com>
 <BANLkTikskhqNk3NihqJ5kZhFqn1YpJEN9A@mail.gmail.com>
In-Reply-To: <BANLkTikskhqNk3NihqJ5kZhFqn1YpJEN9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Apr 14, 2011 at 04:34:34, Mike Williamson wrote:

> > The I2C driver implements a default platform data
> > so it should actually be legal for a DA8x board to
> > pass NULL platform data. In that case this line
> > will crash. You should either check for pdata to
> > be NULL or just let each board choose whether it
> > needs recovery (I think the better option).
> >
> 
> I actually had a problem with using NULL for pdata with davinci I2C
> and had submitted a patch here that sort of fell on the floor.  The
> problem was that the i2c_davinci_calc_clk_dividers is using
> platform_data without a check as described above.  So at the moment
> using NULL doesn't really work, best as I can tell...
> 
> https://lkml.org/lkml/2010/9/4/119

Looking at this mail chain, it looks like Ben was actually OK
with your first submission and just wanted you to update the
patch description saying that dev->platform_data is accessed
later in the code and that is why it needs to be updated.

I liked your first attempt better and may be you should
try another submission with the patch description updated.

Thanks,
Sekhar

