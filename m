Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1GURWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:22:12 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:51555 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1GURWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:22:11 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] generic_hdlc: Update to current logging forms
References: <cover.1309150683.git.joe@perches.com>
	<d9186716ad410d64b1e09b39408a2f232f178260.1309150684.git.joe@perches.com>
Date: Thu, 21 Jul 2011 21:21:53 +0200
In-Reply-To: <d9186716ad410d64b1e09b39408a2f232f178260.1309150684.git.joe@perches.com>
	(Joe Perches's message of "Sun, 26 Jun 2011 22:01:28 -0700")
Message-ID: <m362mve8xa.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Use pr_fmt, pr_<level> and netdev_<level> as appropriate.

Good to see both are already in David's tree.
-- 
Krzysztof Halasa
