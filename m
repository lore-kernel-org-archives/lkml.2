Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1BVLrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:47:16 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35019 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860Ab1BVLrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:47:15 -0500
Date: Tue, 22 Feb 2011 13:47:10 +0200
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: Bug on Latitude E6410 battery
Message-ID: <20110222114710.GA16596@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there's some sort of weird bug on Latitude's battery as it shows 5600
hours of battery time when it's discharging (gnome-power_manager says
that), here are all files' contents from /sys/class/power_supply/BAT0/:

alarm:			0
charge_full:		5276000
charge_full_design:	5600000
charge_now:		5230000
current_now:		1606000
cycle_count:		0
manufacturer:		Samsung SDI
model_name:		DELL H139107
present:		1
serial_number:		1422
status:			Discharging
technology:		Li-ion
type:			Battery
uevent:			POWER_SUPPLY_NAME=BAT0
			POWER_SUPPLY_STATUS=Discharging
			POWER_SUPPLY_PRESENT=1
			POWER_SUPPLY_TECHNOLOGY=Li-ion
			POWER_SUPPLY_CYCLE_COUNT=0
			POWER_SUPPLY_VOLTAGE_MIN_DESIGN=11100000
			POWER_SUPPLY_VOLTAGE_NOW=12683000
			POWER_SUPPLY_CURRENT_NOW=1606000
			POWER_SUPPLY_CHARGE_FULL_DESIGN=5600000
			POWER_SUPPLY_CHARGE_FULL=5276000
			POWER_SUPPLY_CHARGE_NOW=5230000
			POWER_SUPPLY_MODEL_NAME=DELL H139107
			POWER_SUPPLY_MANUFACTURER=Samsung SDI
			POWER_SUPPLY_SERIAL_NUMBER=1422
voltage_min_design:	11100000
voltage_now:		12683000

BTW, I'm using 2.6.38-rc5

-- 
balbi
