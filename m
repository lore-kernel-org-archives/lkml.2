Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2IWVIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 17:08:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33419 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab2IWVIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 17:08:45 -0400
Date: Sun, 23 Sep 2012 23:09:14 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>, linux-leds@vger.kernel.org
Subject: Re: [PATCH v2] leds: add led_trigger_rename function
Message-ID: <20120923210914.GA1410@gmail.com>
References: <20120915161518.GA1687@gmail.com>
 <1347725924-1760-1-git-send-email-fabio.baltieri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347725924-1760-1-git-send-email-fabio.baltieri@gmail.com>
X-Operating-System: Linux balto-eee 3.6.0-rc3-balto-eee-00469-g06da22f
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bryan,

On Sat, Sep 15, 2012 at 06:18:44PM +0200, Fabio Baltieri wrote:
> Implements a "led_trigger_rename" function to rename a trigger with
> proper locking.
> 
> This assumes that led name was originally allocated in non-constant
> storage.

Did you have any chance to review this patch?

I'm interested into getting some opinion for this feature for use in
another patches currently in a can-next branch.

Thanks,
Fabio

-- 
Fabio Baltieri
