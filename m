Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0IMIQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:16:36 -0400
Received: from waikiki.ops.eusc.inter.net ([84.23.254.155]:58014 "EHLO
	waikiki.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269Ab0IMIQe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:16:34 -0400
X-Greylist: delayed 1038 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 04:16:34 EDT
X-Trace: 4d7c6865696b6f2e6261756b6540736e6166752e64657c38342e3136312e313132
	2e3131337c314f763377592d30303044496c2d50347c31323834333634373534
Date: Mon, 13 Sep 2010 09:59:12 +0200
From: Heiko Bauke <heiko.bauke@snafu.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Realtek Ethernet drivers
Message-ID: <20100913095912.74d7f0f1@tron.localdomain>
In-Reply-To: <20100912223724.GA15934@electric-eye.fr.zoreil.com>
References: <20100912210444.76ebeee6@tron.localdomain>
	<20100912223724.GA15934@electric-eye.fr.zoreil.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Francois,

On Mon, 13 Sep 2010 00:37:25 +0200
Francois Romieu <romieu@fr.zoreil.com> wrote:

> It's probably fixed with one of :
> - 81a95f049962ec20a9aed888e676208b206f0f2e /
> 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
> - 908ba2bfd22253f26fa910cd855e4ccffb1467d0
> - 78f1cd02457252e1ffbc6caa44a17424a45286b8
> 
> [...]
> > P.S. I am running 2.6.32-24-generic on a 32-bit Ubuntu 10.04.1 LTS
> > box.
> 
> Your 2.6.32-24-generic includes :
> - 908ba2bfd22253f26fa910cd855e4ccffb1467d0
> - 78f1cd02457252e1ffbc6caa44a17424a45286b8
> 
> But it misses 81a95f049962ec20a9aed888e676208b206f0f2e and
> 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e

I thank you for your reply. If there is time I will try a more recent
kernel. (For the moment the Realtek drivers are fine for me.) I
know how to (re-)compile distribution kernels and how to compile a
vanilla kernel from kernel.org. However, I have no idea what the
hex-codes you mentioned mean. Can you give me a hint?


	Regards,

	Heiko

-- 
-- Die glücklichen Sklaven sind die erbittertsten Feinde der Freiheit.
-- (Marie von Ebner-Eschenbach, öst. Schriftst., 1830-1916)
-- Number Crunch Blog @ http://numbercrunch.de
--        Heiko Bauke @ http://www.mpi-hd.mpg.de/personalhomes/bauke
