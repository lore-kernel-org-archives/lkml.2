Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1BVMFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:05:02 -0500
Received: from smtprelay06.ispgateway.de ([80.67.31.96]:40868 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1BVMFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:05:01 -0500
Message-ID: <4D63A6BC.9060300@ladisch.de>
Date: Tue, 22 Feb 2011 13:06:20 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Louis-Philippe Allard <lp.allard.1@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Thunar generating kernel oops on Slackware64 machine
References: <AANLkTi=5HJVW-nx34rFaXG6O_rC=QfiFD9muES-rKz=X@mail.gmail.com>
In-Reply-To: <AANLkTi=5HJVW-nx34rFaXG6O_rC=QfiFD9muES-rKz=X@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Louis-Philippe Allard wrote:
> Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
> htpc kernel: Code: f3 90 e9 7c ff ff ff 4c 8d 73 04 4c 8d 7b 08 4c 89
> f7 e8 16 0f 00 00 48 8b 43 10 48 8d 55 b0 4c 89 7d b0 48 89 53 10 48
> 89 45 b8 <48> 89 10 83 ca ff 4c 89 65 c0 89 d0 87 03 ff c8 0f 84 88 00
> 00
> 
> Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
> htpc kernel: CR2: 0000000000000000
> 
> Message from syslogd@htpc at Wed Feb  9 20:01:28 2011 ...
> htpc kernel: CR2: 0000000000000000

A complete oops contains more information than this; search for this
somewhere in /var/log/messages.


Regards,
Clemens
