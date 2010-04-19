Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0DSIGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 04:06:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59238 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab0DSIGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 04:06:43 -0400
X-Sasl-enc: VDCvDd9SKG1Z86uFZLrn5jyv1xfPuKsAN/K40/W7HRXs 1271664402
Message-ID: <4BCC0F10.3070208@ladisch.de>
Date: Mon, 19 Apr 2010 10:06:40 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Peter Henriksson <peter.henriksson@gmail.com>
CC: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [regression, bisected] Xonar DX invalid PCI I/O range since 977d17bb174
References: <4BCBFE89.9070401@ladisch.de> <o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>
In-Reply-To: <o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Henriksson wrote:
> > Unfortunately, the bug tracker is dead, so I cannot ask for further
> > information.  (If somebody renews the domain, this report will be at
> > <https://bugtrack.alsa-project.org/alsa-bug/view.php?id=4982>.)
> 
> I am the one who that filed the bug. Please let me know what you need.

Please show the complete kernel log and the contents of /proc/ioports.


Regards,
Clemens
