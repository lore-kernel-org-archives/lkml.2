Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab2FAPjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:39:44 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14840 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2FAPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:39:42 -0400
Message-ID: <1338565180.2618.9.camel@lorien2>
Subject: Re: [PATCH v2 1/3] leds: add oneshot blink functions
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: shuahkhan@gmail.com, Bryan Wu <bryan.wu@canonical.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Date: Fri, 01 Jun 2012 09:39:40 -0600
In-Reply-To: <20120531210800.GB2400@gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
	 <1338135226.2968.22.camel@lorien2> <20120531210800.GB2400@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> There should be no compatibity issues with current timer-trigger calls,
> can you be more specific?

My initial thought was that maybe you could create new namespace for
this trigger instead of using delay_on and delay_off. However, after
looking closely at the patch set you are proposing, since you are using
delay_on and delay_off in led_cdev, I think you are ok.


Please make sure there is no regression in the ledtrig-timer use-cases,
with the changes made to led-class and led-core. 

-- Shuah


