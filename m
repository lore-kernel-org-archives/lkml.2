Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0LQPPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:15:37 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:43693 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754877Ab0LQPPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:15:36 -0500
MIME-Version: 1.0
In-Reply-To: <87ei9kwa9w.fsf@deeprootsystems.com>
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
	<87tyild2ms.fsf@deeprootsystems.com>
	<AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
	<AANLkTi=HiJGwtznGRzFDz-4ywsB3rYPW0yF5U_RUruzV@mail.gmail.com>
	<8762ux49w7.fsf@deeprootsystems.com>
	<AANLkTikUoKPG4o1+pt9r6V6H+6LrwZpTN8X9X+AkimiB@mail.gmail.com>
	<87ei9kwa9w.fsf@deeprootsystems.com>
Date: Fri, 17 Dec 2010 10:15:35 -0500
Message-ID: <AANLkTi=5vORsc4vxP60rBm5mWr=Ndt47SBFeEL5Guk9c@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] da850-evm: add gpio-{keys,leds} for UI and BB expanders
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Tue, Dec 14, 2010 at 12:10 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Just pushed an updated version, and this time, I actually build tested for
> davinci_all_defconfig and da8xx_omapl_defconfig. :)
>
> Sorry for the churn,

I tested linux-davinci master; HEAD was
c63d0f1df0284f2fcb28c0943b17848500d01515. Everything is working as
expected.

Thanks again for taking up this series along with the complications
introduced by the cherry pick.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
