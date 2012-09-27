Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2I0UFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 16:05:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab2I0UFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 16:05:40 -0400
Date: Thu, 27 Sep 2012 22:05:38 +0200
From: Jan Kara <jack@suse.cz>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Jan Kara <jack@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
Message-ID: <20120927200538.GC12553@quack.suse.cz>
References: <50531629.9020107@ahsoftware.de>
 <20120925110206.GD28937@mwanda>
 <50643C4A.9010202@ahsoftware.de>
 <20120927151232.GA12210@quack.suse.cz>
 <506474E8.3030300@ahsoftware.de>
 <50647CCC.7010407@ahsoftware.de>
 <5064945C.4020403@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5064945C.4020403@ahsoftware.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-09-12 20:01:00, Alexander Holler wrote:
> [  111.087356] EXT4-fs (sdc1): mounted filesystem with ordered data
> mode. Opts: (null)
> [  672.868948] CPU4: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  672.868949] CPU0: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  672.869970] CPU0: Core temperature/speed normal
> [  672.869971] CPU4: Core temperature/speed normal
> [  688.285419] CPU6: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  688.285421] CPU2: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  688.286442] CPU2: Core temperature/speed normal
> [  688.286443] CPU6: Core temperature/speed normal
> [  698.822614] CPU3: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  698.822615] CPU7: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  698.824674] CPU3: Core temperature/speed normal
> [  698.824675] CPU7: Core temperature/speed normal
> [  706.979633] CPU1: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  706.979635] CPU5: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  706.980648] CPU1: Core temperature/speed normal
> [  706.980649] CPU5: Core temperature/speed normal
> [  899.540485] [Hardware Error]: Machine check events logged
  This last message usually means hardware really has an issue. You can
use mcelog tool to find out what problems did the hardware report.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
