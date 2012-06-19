Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2FSX4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:56:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45402 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2FSX4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:56:45 -0400
Date: Tue, 19 Jun 2012 16:54:48 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] power_supply: Add charge_current and charge_voltage
 properties and use it in smb347
Message-ID: <20120619235445.GC12508@lizard>
References: <1336308404-25129-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336308404-25129-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 06:16:44PM +0530, Ramakrishna Pallala wrote:
> Constant Charge Current(CC) is charging parameter which limit the
> maximum current which can be pumped into the battery during charge cycle.
> 
> Constant Charge Voltage(CV) is also charging parameter which limit the
> maximum voltage that battery can reach during charge cycle.
> 
> It is very common practice that at low or high temperatures we
> do not charge the batteries upto it's fullest charge voltage
> to avoid battery and user safety issues.
> 
> These sysfs properties will be useful for debug and to implement
> certain user space policies like "Charging limited due to OverTemp".
> 
> This patch also makes use of these two properties in smb347 charger driver.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---

Applied, thank you. (FYI: I split the patch into two: power_supply
part and smb347 part.)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
