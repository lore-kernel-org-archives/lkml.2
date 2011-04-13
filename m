Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab1DMHDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:03:05 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:52931 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756853Ab1DMHDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:03:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANxJpU1R8KzB/2dsb2JhbACmBnjEPg6FYASUFw
Date: Wed, 13 Apr 2011 09:03:00 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Nat Gurumoorthy <natg@google.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Mike Waychison <mikew@google.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v5 1/2] Use "request_muxed_region" in it87 watchdog
	drivers
Message-ID: <20110413070259.GE4070@infomag.iguana.be>
References: <1302641290-30212-1-git-send-email-natg@google.com> <1302641387-30264-1-git-send-email-natg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302641387-30264-1-git-send-email-natg@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nat,

> +	(void) request_muxed_region(REG, 2, NAME);

Why do we need to typecast this? Can't we just use 
+	request_muxed_region(REG, 2, NAME);

Kind regards,
Wim.


