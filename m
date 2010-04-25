Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0DYNFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:05:13 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:55522 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0DYNFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:05:11 -0400
Date: Sun, 25 Apr 2010 15:04:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
To: "Hans-Peter Jansen" <hpj@urpla.net>
Cc: xfs@oss.sgi.com, Nick Piggin <npiggin@suse.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
 [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100425150454.29332472@galadriel.home>
In-Reply-To: <201004250030.40867.hpj@urpla.net>
References: <201004050049.17952.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net>
	<20100424232320.71f764eb@galadriel.home>
	<201004250030.40867.hpj@urpla.net>
Organization: Intellique
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sun, 25 Apr 2010 00:30:40 +0200 vous écriviez:

> I guess, you're not on this specific openSUSE git version of
> 2.6.32.11 (e.g. the preparation for SP1 of SLE11), which, as usual,
> carries a lot of stuff from later kernels.

No, I always use pristine unpatched kernel.org releases, no SELinux, no
nothing. Just another confirmation I should go on this way :)

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------
