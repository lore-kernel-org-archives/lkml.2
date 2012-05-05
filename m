Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab2EEDqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 23:46:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62410 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758995Ab2EEDqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 23:46:42 -0400
Date: Fri, 4 May 2012 20:45:18 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add voltage_ocv property and use it for
 max17042 driver
Message-ID: <20120505034517.GB3285@lizard>
References: <1334055080-19521-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1334055080-19521-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 04:21:20PM +0530, Ramakrishna Pallala wrote:
> This adds a new sysfs file called 'voltage_ocv' which gives the
> Open Circuit Voltage of the battery.
> 
> This property can be used for platform shutdown policies and
> can be useful for initial capacity estimations.
> 
> Note: This patch is generated against linux-next branch.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---
>  Documentation/power/power_supply_class.txt |    2 ++
>  drivers/power/max17042_battery.c           |    8 ++++++++
>  drivers/power/power_supply_sysfs.c         |    1 +
>  include/linux/power_supply.h               |    2 ++
>  4 files changed, 13 insertions(+), 0 deletions(-)

This looks great, applied.

Thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
