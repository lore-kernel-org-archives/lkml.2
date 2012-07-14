Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab2GNBjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 21:39:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48725 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2GNBjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 21:39:32 -0400
Date: Fri, 13 Jul 2012 18:37:27 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] charger-manager: Use EXTCON Subsystem to control
 charger cable
Message-ID: <20120714013727.GA9556@lizard>
References: <1342072996-9391-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1342072996-9391-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 03:03:16PM +0900, Chanwoo Choi wrote:
> This patchset add support EXTCON Subsystem in which charger-manager identify
> the type of external connector and enable/disable charger(regulator) according
> to the state of charger cable(external connector).

Applied, thanks a lot!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
