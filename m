Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0LPP6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:58:15 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:42104 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab0LPP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:58:14 -0500
Date: Thu, 16 Dec 2010 16:58:10 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20101216155810.GG10333@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Andrew Morton <akpm@linux-foundation.org>
References: <cover.1290599843.git.lasaine@lvk.cs.msu.su>
 <be0cb37e4c675ec6b65ccb7d0feef5ade01d2eab.1290599845.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be0cb37e4c675ec6b65ccb7d0feef5ade01d2eab.1290599845.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv5 16/17] pps: add parallel port PPS client
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 07:15:54PM +0300, Alexander Gordeev wrote:
> Add parallel port PPS client. It uses a standard method for capturing
> timestamps for assert edge transitions: getting a timestamp soon after
> an interrupt has happened. This is not a very precise source of time
> information due to interrupt handling delays. However, timestamps for
> clear edge transitions are much more precise because the interrupt
> handler continuously polls hardware port until the transition is done.
> Hardware port operations require only about 1us so the maximum error
> should not exceed this value. This was my primary goal when developing
> this client.
> Clear edge capture could be disabled using clear_wait parameter.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
