Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0GAKF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 06:05:28 -0400
Received: from compulab.co.il ([67.18.134.219]:33491 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711Ab0GAKF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 06:05:27 -0400
Message-ID: <4C2C68B6.6010004@compulab.co.il>
Date: Thu, 01 Jul 2010 13:06:46 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] gpio: introduce f71808e_gpio driver for F71808E Super
 I/O chip.
References: <533693.91394.qm@web180305.mail.gq1.yahoo.com>
In-Reply-To: <533693.91394.qm@web180305.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If so as it8761e_gpio must be moved to drivers/mfd too.

On 06/30/2010 07:37 PM, David Brownell wrote:
> My first reaction is that this whole chip, including
> its GPIO support, would best live in drivers/mfd like
> various other multi-function devices.
> 
> I'm trying to avoid cluttering drivers/gpio with fragments of chip support that don't stand on their own...
> 
> 


-- 
Denis
