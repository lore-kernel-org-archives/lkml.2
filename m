Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2HWEfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:35:47 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35671 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2HWEfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:35:44 -0400
Date: Wed, 22 Aug 2012 21:33:10 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] charger-manager: Stop charging when charge cable is
 detached and code clean
Message-ID: <20120823043310.GA31582@lizard>
References: <1343365285-3462-1-git-send-email-cw00.choi@samsung.com>
 <20120823031002.GA16674@lizard>
 <5035B12F.8090105@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5035B12F.8090105@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 01:27:27PM +0900, Chanwoo Choi wrote:
[...]
> I did send additional patchset which has 5 patch and also include below
> patch list,
> if you may confuse due to duplicate patch, so I inform to you about
> duplicate patch.
> 
> Chanwoo Choi (2):
>    charger-manager: Disable regulator for charging when charger cable is
>      detached
>    charger-manager: Use replacement variable to check state of battery

Understood, thanks for the heads up!

The third patch of 0/5 patch set needs a thoughtful review,
I'll surely get to it, but not today.

Anton.
