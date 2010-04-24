Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab0DXVXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 17:23:39 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:56268 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0DXVXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 17:23:38 -0400
Date: Sat, 24 Apr 2010 23:23:20 +0200
From: Emmanuel Florac <eflorac@intellique.com>
To: "Hans-Peter Jansen" <hpj@urpla.net>
Cc: xfs@oss.sgi.com, Nick Piggin <npiggin@suse.de>,
       opensuse-kernel@opensuse.org, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
 [bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100424232320.71f764eb@galadriel.home>
In-Reply-To: <201004241844.23482.hpj@urpla.net>
References: <201004050049.17952.hpj@urpla.net>
	<20100413091823.GD7544@dastard>
	<201004131142.33518.hpj@urpla.net>
	<201004241844.23482.hpj@urpla.net>
Organization: Intellique
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 24 Apr 2010 18:44:22 +0200 vous écriviez:

> Greg, you might search for a server using xfs filesystems and and a
> i586 kernel >= 2.6.33, (2.6.32.11 of SLE11-SP1 will serve as well),
> log in as an ordinary user, do a "du" on /usr, and wait for the other
> users screaming...

I did precisely that, and didn't notice anything special (du on kernel
source tree) kernel 2.6.32.11, deadline scheduler, 7 drives RAID-6
array, 8GB RAM.

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------
