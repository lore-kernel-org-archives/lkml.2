Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1EJMQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:16:15 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:45824 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754823Ab1EJMQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:16:13 -0400
Subject: Re: [PATCH V2] omap2/omapfb: make DBG() more resistant in if-else
 constructions
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Niels de Vos <ndevos@redhat.com>
Cc: linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sanjeev Premi <premi@ti.com>
In-Reply-To: <1305025653-17138-1-git-send-email-ndevos@redhat.com>
References: <BANLkTinEJZ=fvJmWRkQ7kKyxbFRaJnum7g@mail.gmail.com>
	 <1305025653-17138-1-git-send-email-ndevos@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 15:16:07 +0300
Message-ID: <1305029767.2045.42.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 12:07 +0100, Niels de Vos wrote:
> When DBG() is used in a simple if-else, the resulting code path
> currently depends on the definition of DBG(). Inserting the statement in
> a "do { ... } while (0)" prevents this possible misuse.
> 
> Signed-off-by: Niels de Vos <ndevos@redhat.com>

Thanks, I'll add this to the dss2 tree.

 Tomi


