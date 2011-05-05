Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1EEIqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:46:47 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:46420
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751744Ab1EEIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:46:46 -0400
Message-ID: <4DC263EA.4080502@compulab.co.il>
Date: Thu, 05 May 2011 11:46:34 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: srinath@mistralsolutions.com
CC: linux-omap@vger.kernel.org, jdk@ti.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, khilman@deeprootsystems.com,
        nagendra@mistralsolutions.com, umeshk@mistralsolutions.com
Subject: Re: [Patch v1] AM35xx-Craneboard:Update
References: <1304579708-16018-1-git-send-email-srinath@mistralsolutions.com>
In-Reply-To: <1304579708-16018-1-git-send-email-srinath@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinath,


On 05/05/11 10:15, srinath@mistralsolutions.com wrote:

> From: Srinath.R <srinath@mistralsolutions.com>
>
> Replaced gpio_request()/gpio_direction_output() with gpio_request_one() in am3517_crane_init.

This has been already done and waits for Tony to apply.
Please, see:
http://www.spinics.net/lists/arm-kernel/msg123823.html


-- 
Regards,
Igor.

