Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0LPP40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:56:26 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:42077 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0LPP4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:56:24 -0500
Date: Thu, 16 Dec 2010 16:55:33 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Jiri Kosina <jkosina@suse.cz>, John Stultz <johnstul@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org
Message-ID: <20101216155533.GF10333@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Randy Dunlap <rdunlap@xenotime.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Weber <weber@corscience.de>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jiri Kosina <jkosina@suse.cz>, John Stultz <johnstul@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
 <0f364a4dca1d9680b90be297b2c4f2d171f42168.1290599845.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f364a4dca1d9680b90be297b2c4f2d171f42168.1290599845.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv5 15/17] pps: add kernel consumer support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 07:15:53PM +0300, Alexander Gordeev wrote:
> Add an optional feature of PPSAPI, kernel consumer support, which uses
> the added hardpps() function.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
