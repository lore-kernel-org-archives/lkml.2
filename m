Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2L3O1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 09:27:18 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:65363 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2L3O1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 09:27:16 -0500
Date: Sun, 30 Dec 2012 16:27:10 +0200
From: Ido Yariv <ido@wizery.com>
To: "steve.zhan" <zhanzhenbo@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] hwspinlock/core: Add testing capabilities
Message-ID: <20121230142710.GA16250@WorkStation.localnet>
References: <CAKvkGKfc5jw+_ABgB8nrX37B7zHCoA5Ld0Gs5O-EDFD-Gk0OKg@mail.gmail.com>
 <20121230112018.GA14042@WorkStation.localnet>
 <CAKvkGKep9Fgib=iwCE4RnBWrfsMkJu4CcpNxUDqnkyHpkjohuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKvkGKep9Fgib=iwCE4RnBWrfsMkJu4CcpNxUDqnkyHpkjohuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Sun, Dec 30, 2012 at 10:13:08PM +0800, steve.zhan wrote:
> Hi,
>    Acked-by: Steve zhan zhanzhenbo@gmail.com
>  
>    "I'd rather not test the spinlocks after they are registering as they
> might already be in use by then."
> 
>     Why? I think user must use it after hwspin_lock_register have retured
> sucess.

Once the spinlocks are registered anyone can request and acquire these.
The tests could then interfere with any users of the hwspinlock layer,
or simply fail (because the spinlocks might already be acquired).

Thanks,
Ido.
