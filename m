Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0LORxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:53:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54974
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318Ab0LORxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:53:46 -0500
Date: Wed, 15 Dec 2010 09:54:14 -0800 (PST)
Message-Id: <20101215.095414.193705657.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-12-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101215155642.GE2377@tuxdriver.com>
References: <20101215155642.GE2377@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 15 Dec 2010 10:56:42 -0500

> This is a batch of fixes intended for 2.6.37.
> 
> The biggest changes fix an issue where the iwlagn driver will misread
> the EEPROM information for some devices that will soon be in the wild.
> The initial impulse was to rewrite the EEPROM code, but I pushed back on
> that for 2.6.37.  The compromise is to add the new EEPROM reading code,
> but only to invoke it for the new devices.  Older devices will still use
> the existing (and tested) EEPROM code.  Note that all devices will use
> the new code in 2.6.38 and beyond.
> 
> This also includes a pull of bluetooth fixes from Gustavo Padovan.  That
> includes a null pointer fix and a fix for a regression that broke the
> DUN profile -- say goodbye to your emergency cell-phone Internet
> connection without that!
> 
> Other patches include some device ID additions for p54usb, a fix to
> avoid log spam resulting from suspend/resume with USB-based wireless
> devices that don't define their own suspend hook, a null ptr fix for the
> libertas driver, and another null pointer fix related to IBSS merges.
> 
> Please let me know if there are problems!

Looks good, pulled, thanks John.
