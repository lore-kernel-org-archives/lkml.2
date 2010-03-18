Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0CRNpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:45:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42353 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0CRNpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:45:17 -0400
Date: Thu, 18 Mar 2010 09:42:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Florian Mickler <florian@mickler.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Valdis.Kletnieks@vt.edu,
       Marcel Holtmann <marcel@holtmann.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] rename new rfkill sysfs knobs
Message-ID: <20100318134215.GA17357@tuxdriver.com>
References: <20100313095626.GB16038@core.coreip.homeip.net> <1268483465-11810-1-git-send-email-florian@mickler.org> <20100318115917.64b7268f@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318115917.64b7268f@schatten.dmk.lab>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 11:59:17AM +0100, Florian Mickler wrote:
> On Sat, 13 Mar 2010 13:31:05 +0100
> florian@mickler.org wrote:
> 
> > This patch renames the (never officially released) sysfs-knobs
> > "blocked_hw" and "blocked_sw" to "hard" and "soft", as the hardware vs
> > software conotation is misleading.
> > 
> > It also gets rid of not needed locks around u32-read-access.
> > 
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> 
> Is this ok?

Yes, fine.  Sorry, I got distracted by some other things.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
