Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab2GLW1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:27:09 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:39946 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab2GLW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:27:06 -0400
Date: Fri, 13 Jul 2012 00:14:53 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: Remove rtl_ocpdr_cond
Message-ID: <20120712221453.GA1982@electric-eye.fr.zoreil.com>
References: <1342009916-1519-1-git-send-email-hayeswang@realtek.com> <20120711220045.GA8913@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120711220045.GA8913@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu <romieu@fr.zoreil.com> :
[...]
> I'll try again tomorrow evening.

W/o firmware does not seem to make a difference.

# ping -qf -l 4 -s 81 -c 60 10.0.3.1
PING 10.0.3.1 (10.0.3.1) 81(109) bytes of data.

--- 10.0.3.1 ping statistics ---
60 packets transmitted, 60 received, 0% packet loss, time 153ms
rtt min/avg/max/mdev = 0.047/0.064/0.117/0.016 ms, pipe 4, ipg/ewma 2.607/0.058 ms

# ping -qf -l 4 -s 82 -c 60 10.0.3.1                                                     
PING 10.0.3.1 (10.0.3.1) 82(110) bytes of data.

--- 10.0.3.1 ping statistics ---
60 packets transmitted, 60 received, 0% packet loss, time 3ms
rtt min/avg/max/mdev = 0.195/0.210/0.281/0.018 ms, pipe 4, ipg/ewma 0.057/0.205 ms

It would translate into a 127/128 cutoff after inclusion of the FCS.

Any idea ?

-- 
Ueimor
