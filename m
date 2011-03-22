Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1CVWnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:43:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53489 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753063Ab1CVWnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:43:04 -0400
Date: Tue, 22 Mar 2011 22:43:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Deadlock scenario in regulator core
Message-ID: <20110322224316.GA10841@opensource.wolfsonmicro.com>
References: <4D891C59.1030009@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D891C59.1030009@codeaurora.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 03:02:01PM -0700, David Collins wrote:

> enable the parent regulator?  Likewise, is the lock around
> _notifier_call_chain required?

For this: we don't want the chain changing under us and the chain is
protected by the mutex.
