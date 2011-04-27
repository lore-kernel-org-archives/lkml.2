Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab1D0TVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:21:05 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:56019 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1D0TVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:21:03 -0400
X-Greylist: delayed 1454 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Apr 2011 15:21:03 EDT
Date: Wed, 27 Apr 2011 20:56:43 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: James Nuss <jamesnuss@nanometrics.ca>
Cc: Ricardo Martins <rasm@fe.up.pt>, Ben Gardiner <bengardiner@nanometrics.ca>,
        linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20110427185643.GD20971@gundam.enneenne.com>
Mail-Followup-To: James Nuss <jamesnuss@nanometrics.ca>,
	Ricardo Martins <rasm@fe.up.pt>,
	Ben Gardiner <bengardiner@nanometrics.ca>,
	linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
References: <1303928054-14662-2-git-send-email-jamesnuss@nanometrics.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303928054-14662-2-git-send-email-jamesnuss@nanometrics.ca>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/2] pps: default echo function
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 02:14:13PM -0400, James Nuss wrote:
> A default echo function has been provided so it is no longer an
> error when you specify PPS_ECHOASSERT or PPS_ECHOCLEAR without an explicit
> echo function. This allows some code re-use and also makes it easier
> to write client drivers since the default echo function does not
> normally need to change.
> 
> Signed-off-by: James Nuss <jamesnuss@nanometrics.ca>
> Reviewed-by: Ben Gardiner <bengardiner@nanometrics.ca>

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
