Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1DPONe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:13:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37431 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1DPON1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=LGnHMAzXmnYcTTZkuO6TPghE7IkPJkpqUnpcf1v/F5vwCFxPSEj24X+LG5dptAjv5N
         a60K5G/1IK+q9qN9W7+7o7GYjoed29tAhjYqu4CS/DPzvel9s5XrEf+e7tD7w+Ad9Le9
         KYwTpKa1CjnG3vL0K6gl5FbD+fE4r9lY1wnAk=
MIME-Version: 1.0
In-Reply-To: <BANLkTinNoX6GBG=6xVC8ZfOO4OyZ_o=sFg@mail.gmail.com>
References: <1302781431.21145.6.camel@dev.znau.edu.ua> <BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
 <4DA6E9BD.3090404@hauke-m.de> <BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com>
 <1302786900.21965.52.camel@dev.znau.edu.ua> <BANLkTimM8=-pX+Ea8Eyp4XyvP1APbUof9w@mail.gmail.com>
 <1302892585.30441.12.camel@dev.znau.edu.ua> <BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
 <1302896541.30441.33.camel@dev.znau.edu.ua> <BANLkTinPVaYC14Y=m5iu7GYodkRb6uTuPw@mail.gmail.com>
 <20110415195642.22440.qmail@stuge.se> <BANLkTinNoX6GBG=6xVC8ZfOO4OyZ_o=sFg@mail.gmail.com>
From: Jonas Gorski <jonas.gorski+openwrt@gmail.com>
Date: Sat, 16 Apr 2011 16:13:06 +0200
X-Google-Sender-Auth: mHvQB7oxZzehV3RjD2zfAEmOv_U
Message-ID: <BANLkTinXUt1aNudnRqEG40vcrtMBCc3Nxg@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Arend van Spriel <arend@broadcom.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-arm-kernel@lists.infradead.org, b43-dev@lists.infradead.org,
        Peter Stuge <peter@stuge.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2011 16:00, Rafał Miłecki <zajec5@gmail.com> wrote:
> Of the other point there is no sense in calling it
> bcm_amba_axi_for_wifi as I believe we can meet other devices than just
> wifi on this architecture.

Current bcm47xx/53xx SoCs from Broadcom also use this architecture for
the system bus (like the older ones used SSB), and they usually have
ethernet macs, memory controllers, mips cores on it (and, as far as I
can see, also always a 802.11 core).


Jonas
