Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab0FWMp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 08:45:28 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:51116 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab0FWMp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 08:45:27 -0400
Message-ID: <4C2201DF.9050500@ladisch.de>
Date: Wed, 23 Jun 2010 14:45:19 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: sboyce@blueyonder.co.uk, Daniel Mack <daniel@caiaq.de>
CC: alsa-devel@alsa-project.org, alsa-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.35-rc3 E-MU 0404 USB problem
References: <4C20B364.9060405@blueyonder.co.uk> <20100622131102.GA18432@kroah.com> <20100622133434.GZ2698@buzzloop.caiaq.de> <4C21E875.20200@blueyonder.co.uk>
In-Reply-To: <4C21E875.20200@blueyonder.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-usb@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sid Boyce wrote:
>>>> Transmit fails,

What exactly fails?

>>>> dmesg output with 48K sample rate set is:-
>>>> ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks sample rate attribute bit, cannot set.

There are many devices that have only one sample rate or that have one
sample rate per alternate setting.  This doesn't deserve a message, much
less a warning.


Regards,
Clemens
