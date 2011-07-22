Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1GVXXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 19:23:21 -0400
Received: from mail001.aei.ca ([206.123.6.130]:49461 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab1GVXXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 19:23:20 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt1
Date: Fri, 22 Jul 2011 19:23:17 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-crc+; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.02.1107222203400.2702@ionos>
In-Reply-To: <alpine.LFD.2.02.1107222203400.2702@ionos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107221923.17455.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 July 2011 16:37:24 Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0-rt1 release.

Thomas,

It does not build here with CONFIG_RCU_TORTURE_TEST=m

Without that it build here on amd64.

Thanks,
Ed
