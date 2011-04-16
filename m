Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab1DPRyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 13:54:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51980 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751002Ab1DPRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 13:54:33 -0400
Date: Sat, 16 Apr 2011 18:54:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: wanlong.gao@gmail.com
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, lrg@slimlogic.co.uk
Subject: Re: [PATCH]drivers:regulator:change the dev_dbg in the probe function
Message-ID: <20110416175440.GD25811@opensource.wolfsonmicro.com>
References: <1302968543-3150-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302968543-3150-1-git-send-email-wanlong.gao@gmail.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 11:42:23PM +0800, wanlong.gao@gmail.com wrote:

Please ensure that you use subject lines for your patch which fit in
with the style of other changes to the subsystem.

> change the function name string to "%s".

You should also explain why a change is being made, not what the change
is (we can see that from the patch).  In this case what you're doing is
making this debug statement be consistent with the style of the rest of
the file.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com
