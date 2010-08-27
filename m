Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0H0WO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:14:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9032 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0H0WOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:14:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6087"; a="52508164"
Message-ID: <4C7838DD.1020004@codeaurora.org>
Date: Fri, 27 Aug 2010 18:14:53 -0400
From: Neil Leeder <nleeder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>, Hsin.Wu@quantatw.com
Subject: [PATCH 0/1] input: keyboard: add qci keyboard driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an update of the keyboard driver which Quanta previously posted 
to linux-input. Like the touchpad driver, I'm taking over maintenance 
for code aurora forum.

The keyboard is attached to an embedded controller which is accessed 
through I2C. It has a dedicated I2C address and its own interrupt line, 
so it is not treated as an mfd. Although a PS/2 command, 0xF4, is used 
to initialize the keyboard, the EC does not respond to other PS/2 
commands. I have tried a serio driver on the port and attempted to use 
keyboard drivers like xtkbd to communicate with it. These fail for 
similar reasons to those discussed in the qci touchpad thread. This is 
the reason for having this as a stand-alone driver.

--
Neil
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
