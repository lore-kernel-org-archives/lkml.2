Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab0IICsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 22:48:36 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:7422 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486Ab0IICsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 22:48:30 -0400
Message-ID: <4C884AFA.20604@bluewatersys.com>
Date: Thu, 09 Sep 2010 14:48:26 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stuart Longland <redhatter@gentoo.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Voltage/current/sensor monitoring interface and Wiegand
References: <20100909000245.GK14056@atomos.longlandclan.yi.org>
In-Reply-To: <20100909000245.GK14056@atomos.longlandclan.yi.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2010 12:02 PM, Stuart Longland wrote:
> Hi all,
> 
> I'm currently writing a driver for an in-house developed sensor
> controller device.  This device communicates via I²C, and functions as a
> multi-function device incorporating:
> 
> - Touchscreen controller
> - Keypad/Button controller
> - LED driver
> - Voltage/current monitor
> - Temperature sensor monitor
> - Light sensor monitor
> - PIR (motion) detection monitor
> - Communications interface (for slow serial links like Wiegand)

> How are voltage *monitors* normally written?  (note, not voltage
> *regulators*... this thing does not alter the voltage rails.)  I tried
> to make sense of lm-sensors, but that seems very ad-hoc (maybe I missed
> some document that explains it) to me.  It's hard to be clear on what is
> the *right* way to report a voltage or current reading to userspace.

Depending on your particular application it might make sense to use the
power supply class (see Documentation/power/power_supply_class.txt) for
the voltage/current monitoring. If the temperature sensor is related to
a power supply monitor, then it could also go there.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
