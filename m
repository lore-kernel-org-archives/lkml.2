Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0LPPwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:52:51 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:39804 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab0LPPwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:52:49 -0500
Date: Thu, 16 Dec 2010 16:52:38 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>
Message-ID: <20101216155237.GC10333@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
 <a17c3d890e34d2d0faf24a5b7ea6205cd7a86aa4.1290599844.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a17c3d890e34d2d0faf24a5b7ea6205cd7a86aa4.1290599844.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv5 06/17] pps: access pps device by direct pointer
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 07:15:44PM +0300, Alexander Gordeev wrote:
> Using device index as a pointer needs some unnecessary work to be done
> every time the pointer is needed (in irq handler for example).
> Using a direct pointer is much more easy (and safe as well).
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
