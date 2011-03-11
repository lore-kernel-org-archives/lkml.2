Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1CKPyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:54:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56111 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1CKPyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:54:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: RFC: Platform data for onboard USB assets
Date: Fri, 11 Mar 2011 16:54:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: andy.green@linaro.org, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <4D79F068.2080009@linaro.org> <201103111331.13932.arnd@arndb.de> <20110311152938.GB29920@sirena.org.uk>
In-Reply-To: <20110311152938.GB29920@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111654.04089.arnd@arndb.de>
X-Provags-ID: V02:K0:/zNu6pf7GETAR9MkonbRLKnkUnQ1Q9Xj8jLjhVquuVV
 +DEY2M5ZnTsJDfOmrWfn9OQPYZypsXEm4NUwqFzqkywDkpNc4b
 028XP4uAPVZYnKeusVZnfx2zJhuplBeG23+JYu3McQnWDJMbDt
 yjuTOcJEyXx8lnJg7gDx059kCcKuKkGBApVyNKD4S1C2UhYAZ+
 QQ3zd/Qgoqx3w5P0G5ruQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 March 2011, Mark Brown wrote:
> On Fri, Mar 11, 2011 at 01:31:13PM +0100, Arnd Bergmann wrote:
> 
> > I understand the problem, but IMHO there really needs to be a better
> > solution for this. As far as I understand, the underlying problem is
> > that USB ethernet devices with a proper MAC address get a different
> > device name from devices with a generated random MAC address, and
> > the people that designed this board were trying to save a few cents
> > by not allocating a MAC address for the ethernet device [1], right?
> 
> > I believe we should fix this particular problem locally, instead of
> > coming up with generic infrastructure for broken hardware.
> 
> It's arguable if this stuff is broken at all, from a hardware design
> point of view it's perfectly reasonable and if you're shipping volumes
> in the millions very small savings add up to interesting numbers easily.

It may be reasonable if you don't expect anyone to connect the
device to an ethernet port, but in that case you could save much
more by removing the ethernet chip and the socket along with the
eeprom.

Really, any machine without a fixed MAC address is a huge pain
for users, just google for "pandaboard mac address" to see
how much work this has caused people.

	Arnd
