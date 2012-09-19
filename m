Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab2ISIef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:34:35 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:57851 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487Ab2ISIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:34:33 -0400
Subject: Re: [PATCH 2/3] OMAP i2c: pinctrl-ify i2c-omap.c
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <50596F8F.60506@ti.com>
Date: Wed, 19 Sep 2012 11:34:27 +0300
Cc: Benoit Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Tony Lindgren <tony@atomide.com>
Content-Transfer-Encoding: 7bit
Message-Id: <D63B475E-E552-4ED6-9C25-21BC188722ED@antoniou-consulting.com>
References: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com> <1348070841-23354-3-git-send-email-panto@antoniou-consulting.com> <50596F8F.60506@ti.com>
To: Shubhrajyoti <shubhrajyoti@ti.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sep 19, 2012, at 10:09 AM, Shubhrajyoti wrote:

> On Wednesday 19 September 2012 09:37 PM, Pantelis Antoniou wrote:
>> #include <linux/pm_runtime.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <linux/err.h>
> err.h include may be removed.

Right, Updated patch series (without the message patch follows)...

Regards

-- Pantelis


