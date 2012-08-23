Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2HWDNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:13:04 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47097 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab2HWDNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:13:01 -0400
Date: Wed, 22 Aug 2012 20:10:03 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] charger-manager: Stop charging when charge cable is
 detached and code clean
Message-ID: <20120823031002.GA16674@lizard>
References: <1343365285-3462-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343365285-3462-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 02:01:25PM +0900, Chanwoo Choi wrote:
> This patchset fix bug related to stop charging when charger cable is
> detached and check return value of regulator_enable/disable() function
> to confirm correct operation of enabled or disabling regulator for
> charging. Second patch is code clean which remove unnecessary variable
> type.
> 
> Chanwoo Choi (2):
>   charger-manager: Disable regulator for charging when charger cable is
>     detached
>   charger-manager: Use replacement variable to check state of battery
> 
>  drivers/power/charger-manager.c       |   21 ++++++++++++++++++---
>  include/linux/power/charger-manager.h |    3 ---
>  2 files changed, 18 insertions(+), 6 deletions(-)

Both applied, much thanks!
