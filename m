Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0DEXES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 19:04:18 -0400
Received: from us-mx4.synaptics.com ([12.178.49.178]:60520 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab0DEXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 19:04:09 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 05 Apr 2010 14:55:49 -0700
Message-ID: <4BBA6C65.1010300@synaptics.com>
Date: Mon, 5 Apr 2010 16:04:05 -0700
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <WManson@synaptics.com>
Subject: Re: [RFC PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
References: <1269310058-10894-1-git-send-email-cheiny@synaptics.com>	<1269310058-10894-2-git-send-email-cheiny@synaptics.com> <20100402145025.0265a074@hyperion.delvare>
In-Reply-To: <20100402145025.0265a074@hyperion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2010 05:50 AM, Jean Delvare wrote:
> Sorry for the delay. Here finally come my comments on your code. I'm
> only commenting on the i2c side of things.

Hi Jean,

Thanks for the input!  It's quite helpful and clears up some things we 
were a bit puzzled about.  We'll fold most of your suggestions into the 
next patch.  Answers to some questions you raised will be coming shortly.

				Thanks again,
					Chris
