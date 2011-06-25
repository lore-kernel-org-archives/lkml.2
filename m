Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab1FYFpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 01:45:10 -0400
Received: from claw.goop.org ([74.207.240.146]:35976 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab1FYFpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 01:45:06 -0400
Message-ID: <4E0575DE.4070004@goop.org>
Date: Fri, 24 Jun 2011 22:45:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
        marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression caused by "Bluetooth: Map sec_level to link key requirements"
References: <yunboy7a2so.fsf@aiko.keithp.com> <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com> <20110609083345.GA2894@dell.ccr.corp.intel.com> <yuny61b3pnm.fsf@aiko.keithp.com> <99B09243E1A5DA4898CDD8B700111448175AA2DE98@EXMB04.eu.tieto.com> <20110610055558.GA1832@dell> <BANLkTim4F8ZvWPMHSXpcBj9Eb2uFThcz4w@mail.gmail.com> <yun8vsynkiy.fsf@aiko.keithp.com> <20110619175937.GA24188@dell.ger.corp.intel.com> <yunliwxabmz.fsf@aiko.keithp.com>
In-Reply-To: <yunliwxabmz.fsf@aiko.keithp.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2011 12:01 PM, Keith Packard wrote:
>> I think you'll need both of them to fix the pairing/security issues.
> Yup, with both of those patches, I get syncml and dun working again.
>
> (sorry for the delayed testing, I'm traveling)

I just bisected the problems I had reconnecting my Nokia BH-905i
headphones to the same change that Keith identified, and merging
git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
into my tree fixed it.

So +1 from me to get this into mainline soon.

Thanks,
    J
