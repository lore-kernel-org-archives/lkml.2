Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0DBN6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 09:58:43 -0400
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:53331 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0DBN6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 09:58:37 -0400
Date: Fri, 02 Apr 2010 09:58:32 -0400
From: mbreuer@majjas.com
Subject: Re: Hung task - sync - 2.6.33-rc7  w/md6 multicore rebuild in process
In-reply-to: <20100402110123.GG12621@ojjektum.uhulinux.hu>
To: Pozsar Balazs <pozsy@uhulinux.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <154e4a8ded6573684938979a5e0fb1d4.squirrel@mail.majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Importance: Normal
X-Priority: 3 (Normal)
References: <4B76D87E.3050107@majjas.com>
 <20100402110123.GG12621@ojjektum.uhulinux.hu>
User-Agent: SquirrelMail/1.4.20-1.fc12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Hi all,
>
> Was there any solution for this problem? We seem to be hitting the same
> problem with kernel 2.6.33.1, 12G RAM, and raid10. Noatime does not
> help.
>
> Thanks
> Balazs Pozsar
>
>
I reported that I was unable to recreate as op 2.6.33-rc6. I am now on
2.6.34-rc3 and have not seen a recurrence.


