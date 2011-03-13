Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1CMGod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:44:33 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:57115 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1CMGoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:44:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l/6a88UfWtVGxR9OznPzxj2mHHTlnQkZP+bOzbFj9X7u/BW5/jcq+tSOO+fvOBCbb+
         fPQX6XS7bwf/K4sMTJMZCWNyCq9AMjpowNlv5WNJacvtG86n+sJxlBUm4dGWeRu8Z3LI
         InPuCkCT4HhWaHLNKhU9Un0YIWZo4WzlQXSaA=
Date: Sat, 12 Mar 2011 22:44:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: touchscreen: use polling mode in 88pm860x
Message-ID: <20110313064426.GG31566@core.coreip.homeip.net>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:43:14PM +0800, Haojian Zhuang wrote:
> Measuring point on touchscreen with IRQ mode can only monitor pen-down
> event. If finger is moving on touchscreen, it can't be monitored by
> IRQ pen-down event. So switch to polling mode after pen-down event.
> 

Instead of scheduling work you could stay in the interrupt handler
(which is a separate thread) and poll from it. Or is it a nested
interrupt and it is sharing the interrupt thread?

Thanks.

-- 
Dmitry
