Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1H3SA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:00:26 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47943 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab1H3SAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:00:24 -0400
Date: Tue, 30 Aug 2011 13:50:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/mac80211/debugfs: Convert to kstrou8_from_user
Message-ID: <20110830175054.GB2660@tuxdriver.com>
References: <1307478974-32727-1-git-send-email-peterhuewe@gmx.de>
 <201108282152.32180.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201108282152.32180.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 09:52:31PM +0200, Peter Hüwe wrote:
> Am Dienstag 07 Juni 2011, 22:36:14 schrieb Peter Huewe:
> > This patch replaces the code for getting an number from a
> > userspace buffer by a simple call to kstrou8_from_user.
> > This makes it easier to read and less error prone.
> > 
> > Since the old buffer was only 10 bytes long and the value is masked by a
> > nibble-mask anyway, we don't need to use kstrtoul but rather kstrtou8.
> > 
> > Kernel Version: v3.0-rc2
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Any updates on this one?
> Still applies to the latest linus' tree

I merged it to wireless-next yesterday.

Thanks for the reminder!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
