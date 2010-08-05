Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab0HEJRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:17:38 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:46457 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab0HEJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:17:35 -0400
Date: Thu, 5 Aug 2010 11:17:23 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>
Message-ID: <20100805091723.GH26615@gundam.enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Jason Wessel <jason.wessel@windriver.com>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su> <8d5aef7f5bec90d02e93c14c39ec470a449184c5.1280952801.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d5aef7f5bec90d02e93c14c39ec470a449184c5.1280952801.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv3 04/16] pps: unify timestamp gathering
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Aug 05, 2010 at 01:06:41AM +0400, Alexander Gordeev wrote:
> Add a helper function to gather timestamps. This way clients don't have
> to duplicate it.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/pps/clients/pps-ktimer.c |    9 ++-------
>  drivers/pps/clients/pps-ldisc.c  |   18 ++++++------------
>  drivers/pps/kapi.c               |   19 ++++++++++++-------
>  include/linux/pps_kernel.h       |   19 ++++++++++++++++++-
>  include/linux/serial_core.h      |    5 +++--
>  include/linux/tty_ldisc.h        |    5 +++--
>  6 files changed, 44 insertions(+), 31 deletions(-)

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
