Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab0IMTBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:01:55 -0400
Received: from 217.59.140-88.rev.gaoland.net ([88.140.59.217]:46432 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754674Ab0IMTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:01:55 -0400
Date: Mon, 13 Sep 2010 21:00:46 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Heiko Bauke <heiko.bauke@snafu.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Realtek Ethernet drivers
Message-ID: <20100913190046.GA4470@electric-eye.fr.zoreil.com>
References: <20100912210444.76ebeee6@tron.localdomain>
 <20100912223724.GA15934@electric-eye.fr.zoreil.com>
 <20100913095912.74d7f0f1@tron.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913095912.74d7f0f1@tron.localdomain>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Bauke <heiko.bauke@snafu.de> :
> Francois Romieu <romieu@fr.zoreil.com> wrote:
[...]
> > But it misses 81a95f049962ec20a9aed888e676208b206f0f2e and
> > 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
> 
> I thank you for your reply. If there is time I will try a more recent
> kernel. (For the moment the Realtek drivers are fine for me.) I
> know how to (re-)compile distribution kernels and how to compile a
> vanilla kernel from kernel.org. However, I have no idea what the
> hex-codes you mentioned mean. Can you give me a hint?

They are commit ID. See :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=81a95f049962ec20a9aed888e676208b206f0f2e

-- 
Ueimor
