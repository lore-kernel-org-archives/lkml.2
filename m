Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1BDNrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:47:17 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50841 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752300Ab1BDNrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:47:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18YWxgjKYQYx1nvOBYFBDguUIBvUD0D9J6xHER7Bn
	9+D+eS9756DFQw
Subject: Re: 2.6.37 considered stable?
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201102040832.09300.gene.heskett@gmail.com>
References: <795246.25806.qm@web113301.mail.gq1.yahoo.com>
	 <1296825048.8031.32.camel@marge.simson.net>
	 <201102040832.09300.gene.heskett@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 14:47:13 +0100
Message-ID: <1296827233.8031.43.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 08:32 -0500, Gene Heskett wrote:

> Chuckle.  I've been running 2.6.37 here, with all of that new group 
> scheduling stuff enabled, the desktop feels great and my only fuss is that 
> kaffiene, when watching digital tv on my pcHD-3000 card, is NOT getting 
> enough time so both the audio and the video have little 20 millisecond 
> holes chopped in them at sub-second intervals.  Not the most pleasant thing 
> to watch.  I would appreciate any suggestions on how to get such an  
> application a higher priority.

If you have something that really needs tons of CPU, you can try echo
-10 > /proc/pid/autogroup.  If your app has realtime constraints though,
nothing but realtime scheduling will help.

	-Mike


