Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0KTQJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 11:09:52 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:54397 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0KTQJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 11:09:51 -0500
Date: Sat, 20 Nov 2010 17:09:47 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Tejun Heo <tj@kernel.org>
Message-ID: <20101120160947.GB13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <9e636c291cc28c3dda3762230fa595ec6384dbef.1290087479.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e636c291cc28c3dda3762230fa595ec6384dbef.1290087479.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 09/17] pps: don't disable interrupts when using spin
 locks
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 07:01:02PM +0300, Alexander Gordeev wrote:
> Now all PPS spin locks are never used in interrupt context so we can
> safely replace spin_lock_irq*/spin_unlock_irq* with plain
> spin_lock/spin_unlock.

This patch must be delayed till the previous one is not fixed.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
