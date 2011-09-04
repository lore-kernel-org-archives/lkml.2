Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab1IDPrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 11:47:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:38333 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1IDPq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 11:46:58 -0400
Date: Sun, 4 Sep 2011 17:46:27 +0200
From: Florian Mickler <florian@mickler.org>
To: piotr@hosowicz.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Some regression since rc3
Message-ID: <20110904174627.7506c6ff@schatten.dmk.lab>
In-Reply-To: <4E5A651A.6020005@example.com>
References: <4E5A651A.6020005@example.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Aug 2011 17:56:10 +0200
Piotr Hosowicz <piotr@hosowicz.com> wrote:

> Hi,
> 
> I almost cannot work. I tried todays rc3-git3 and I see that icedove 
> mailer keeps growing almost instantly to 100% cpu. I tried rc3-git3 but 
> to no avail. I am booted on plain rc3 now and I can work, but not 
> perfect still as before.
> 
> Regards,
> 
> Piotr Hosowicz
> 

Not enough information. It would be interesting to see what icedove is
doing. GDB or strace might give a hint. 

If this is still a problem with current git and it is reproducible, can
you bisect which change caused this?

Regards,
Flo
