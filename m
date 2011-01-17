Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab1AQFVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 00:21:37 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:12573 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1AQFVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 00:21:36 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
From: Roland Dreier <rdreier@cisco.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [PATCH 01/30] infiniband: update workqueue usage
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	<1292086307-19211-2-git-send-email-tj@kernel.org>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 16 Jan 2011 21:21:32 -0800
In-Reply-To: <1292086307-19211-2-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Sat, 11 Dec 2010 17:51:18 +0100")
Message-ID: <adamxn0yujn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I went ahead and applied Tejun's patch, since I think it should be no
worse than what we have now... I agree the qib stuff looks fine.

 - R.
