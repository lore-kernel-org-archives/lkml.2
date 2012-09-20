Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab2ITVvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:51:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2ITVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:51:02 -0400
Date: Thu, 20 Sep 2012 14:48:16 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] smb347_charger: fix battery status reporting logic
 for charger faults
Message-ID: <20120920214816.GB18223@lizard>
References: <1347985687-22676-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120919073734.GO15548@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120919073734.GO15548@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 10:37:34AM +0300, Mika Westerberg wrote:
> On Tue, Sep 18, 2012 at 09:58:07PM +0530, Ramakrishna Pallala wrote:
> > This patch checks for charger status register for determining the
> > battery charging status and reports Discharing/Charging/Not Charging/Full
> > accordingly.
> > 
> > This patch also adds the interrupt support for Safety Timer Expiration.
> > This interrupt is helpful in debugging the cause for charger fault.
> > 
> > Resending this patch because previous patch missed Anton's attention

Not that it missed my attention, it's just that I'm in "apply-mode"
only 3-4 times per dev cycle. So, patches may lay in my "battery"
folder for some time.

That's mostly because I have somewhat limited time, but also that way I
can collect Acks and give other folks a chance to take a look at the
patches.  :-)

But if you suspect the patch missed my attention (which also happens
sometimes), it's totally fine to resend it or ping me, as you did.

> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thank you guys!
