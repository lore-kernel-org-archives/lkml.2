Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0CRK7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:59:25 -0400
Received: from ist.d-labs.de ([213.239.218.44]:38838 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0CRK7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:59:23 -0400
Date: Thu, 18 Mar 2010 11:59:17 +0100
From: Florian Mickler <florian@mickler.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: florian@mickler.org, "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       Valdis.Kletnieks@vt.edu, "Marcel Holtmann" <marcel@holtmann.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] rename new rfkill sysfs knobs
Message-ID: <20100318115917.64b7268f@schatten.dmk.lab>
In-Reply-To: <1268483465-11810-1-git-send-email-florian@mickler.org>
References: <20100313095626.GB16038@core.coreip.homeip.net>
	<1268483465-11810-1-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Mar 2010 13:31:05 +0100
florian@mickler.org wrote:

> This patch renames the (never officially released) sysfs-knobs
> "blocked_hw" and "blocked_sw" to "hard" and "soft", as the hardware vs
> software conotation is misleading.
> 
> It also gets rid of not needed locks around u32-read-access.
> 
> Signed-off-by: Florian Mickler <florian@mickler.org>

Is this ok?

cheers,
Flo
