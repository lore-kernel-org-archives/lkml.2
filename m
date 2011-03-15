Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab1COB1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 21:27:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52319 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1COB1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 21:27:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D7EC069.6060404@jp.fujitsu.com>
Date: Tue, 15 Mar 2011 10:27:05 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: MCE hardware error, but no message
References: <alpine.LNX.2.01.1103122136220.20070@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1103122136220.20070@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/13 5:49), Jan Engelhardt wrote:
> 
> 
> Running Linux 2.6.37, I am getting these errors on one of a box:
> 
> [696782.810387] [Hardware Error]: No human readable MCE decoding support 
> on this CPU type.
> [696782.810470] [Hardware Error]: Run the message through 'mcelog 
> --ascii' to decode.
> [696783.585853] [Hardware Error]: No human readable MCE decoding support 
> on this CPU type.
> [696783.585937] [Hardware Error]: Run the message through 'mcelog 
> --ascii' to decode.
> 
> Except that it never tells me the actual non-human readable form.
> The error starts to show after 6-48 hours after a reboot (including 
> warm reboots). A second machine of the exact same configuration shows no 
> problems over the past 30 days. Environmental sensors of the problem box 
> show normal parameters.
> 
> How would I get the messages to run through mcelog?

It looks like a kind of corrected error.

Let's try the latest mcelog:
  git://git.kernel.org/pub/scm/utils/cpu/mce/mcelog.git


Thanks,
H.Seto

