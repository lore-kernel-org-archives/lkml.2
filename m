Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab2GNDqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 23:46:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524Ab2GNDqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 23:46:52 -0400
Date: Fri, 13 Jul 2012 20:44:48 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add min/max alert properties for CAPACITY,
 TEMP, TEMP_AMBIENT
Message-ID: <20120714034448.GC20018@lizard>
References: <1341487752-2724-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1341487752-2724-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 04:59:12PM +0530, Ramakrishna Pallala wrote:
> Minimum and maximum alerts on power supply properties will help or allow the
> user space to "proactively" create policies like connect/disconnect charger
> or stop/start the user apps based on capacity or temperature parameters.
> 
> These parameters can be used to avoid unnecessary polling from user space and
> even from kernel space if the underlying HW can support INT triggers(ex: max17042/47).
> 
> This patch adds the following power supply alert type properties:
> CAPACITY_ALERT_MIN
> CAPACITY_ALERT_MAX
> TEMP_ALERT_MIN
> TEMP_ALERT_MAX
> TEMP_AMBIENT_ALERT_MIN
> TEMP_AMBIENT_ALERT_MAX
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>

Looks nice, applied. Thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
