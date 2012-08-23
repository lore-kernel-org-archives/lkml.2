Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2HWFDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:03:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51396 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2HWFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:03:05 -0400
Date: Wed, 22 Aug 2012 22:00:23 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] power_supply: Add new power supply properties
 CHARGE_CURRENT/VOLTAGE_MAX
Message-ID: <20120823050023.GA3233@lizard>
References: <1343632761-3418-1-git-send-email-ramakrishna.pallala@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343632761-3418-1-git-send-email-ramakrishna.pallala@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 12:49:21PM +0530, Ramakrishna Pallala wrote:
> There are different types of chargers avalibale like AC, Solar, USB, etc..
> Even in USB we have different types SDP/DCP/CDP/ACA and all these
> chargers have different o/p ratings. For example SDP supports only 500mA of
> charge current whereas AC charger can support upto 8A or more.
> 
> Similarly batteries also come with charge current and voltage ratings and
> these ratings vary depending on its capacity and the technology used.
> 
> This patch adds two new power supply properties CONSTANT_CHARGE_CURRENT_MAX and
> CONSTANT_CHARGE_CURRENT_MAX.
> 
> Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> ---

Applied, thanks!
