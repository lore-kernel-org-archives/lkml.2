Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0LPPxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:53:39 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:41817 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0LPPxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:53:37 -0500
Date: Thu, 16 Dec 2010 16:53:33 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Tejun Heo <tj@kernel.org>
Message-ID: <20101216155333.GD10333@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Tejun Heo <tj@kernel.org>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
 <9c96d7a57a0a0c7a1e365af086e55460a56788a1.1290599844.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c96d7a57a0a0c7a1e365af086e55460a56788a1.1290599844.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv5 08/17] pps: move idr stuff to pps.c
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 07:15:46PM +0300, Alexander Gordeev wrote:
> Since now idr is only used to manage char device id's and not used in
> kernel API anymore it should be moved to pps.c. This also makes it
> possible to release id only at actual device freeing so nobody can
> register a pps device with the same id while our device is not freed
> yet.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
