Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2BULvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:51:54 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:46634
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160Ab2BULvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:51:52 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH] HWMON: DA9052/53 hwmon driver v2
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <guenter.roeck@ericsson.com>
CC: <randy.dunlap@oracle.com>, <linaro-dev@lists.linaro.org>,
        <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED2B996CD9@KCHJEXMB01.kpit.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED2B996CD9@KCHJEXMB01.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Feb 2012 17:13:48 +0530
Message-ID: <1329824628.30549.187.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 16:48 +0530, Ashish Jangam wrote:
> On Fri, 2012-02-10 at 07:58 -0500, Ashish Jangam wrote:
> > The DA9052 PMIC provides an Analogue to Digital Converter with 10 bits
> > resolution and 10 channels.
> > 
> > +  * Dialog Semiconductors DA9052-BC and DA9053-AA/Bx PMICs
> > +    Prefix: 'da9052'
> > +    Datasheet: Kindly visit www.dialog-semiconductor.com/product_table.php
> > +              and request for the official datasheet.
> > +
> Not really. From practical experience, the datasheet is not available
> except for Dialog Semiconductor customers - not even for me to review
> the driver (and that appears to be independent of my employer's
> relationship with Dialog Semiconductor). I think this should read "not
> publicly available". It is a bit misleading to suggest that it would be
> available if that is not the case.
Agreed.
> 
> > +static const char * const input_names[] = {
> > +       [DA9052_ADC_VDDOUT]     =       "VDDOUT",
> > +       [DA9052_ADC_ICH]        =       "CHARGING CURRENT",
> > +       [DA9052_ADC_TBAT]       =       "BATTERY TEMP",
> > +       [DA9052_ADC_VBAT]       =       "BATTERY VOLTAGE",
> > +       [DA9052_ADC_IN4]        =       "ADC IN4",
> > +       [DA9052_ADC_IN5]        =       "ADC IN5",
> > +       [DA9052_ADC_IN6]        =       "ADC IN6",
> > +       [DA9052_ADC_TJUNC]      =       "BATTERY JUNCTION TEMP",
> > +       [DA9052_ADC_VBBAT]      =       "BACK-UP BATTERY VOLTAGE",
> > +};
> > +
> Where are those defines, or, in other words, which repository/branch is
> your patch based on ? I don't see it in the current mainline kernel.
The incremental ADC patch to the da9052 mfd core takes care of all such
issues. However that patch is still under review...hoping to get it thru
soon.


