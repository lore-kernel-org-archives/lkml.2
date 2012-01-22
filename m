Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2AVJY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 04:24:29 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:44831 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab2AVJYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 04:24:24 -0500
Message-ID: <4F1BD5C4.9000006@msgid.tls.msk.ru>
Date: Sun, 22 Jan 2012 13:24:20 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110805 Icedove/5.0
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: overwriting module params given on kernel command line?
X-Enigmail-Version: 1.2.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I noticed that recent kernels does not allow overwriting
module parameters given on kernel command line anymore.

One particular example of this is ipv6.disable.  I usually
boot kernel with ipv6.disable=1, because all these systems
does not have ipv6 connectivity anyway and v6 isn't needed.
But I remember that in earlier versions it was possible to
specify this parameter in modprobe line:

 rmmod ipv6; modprobe ipv6 disable=0

and v6 were enabled after this reload (rmmod is possible
while it is disabled).  It works in, at least, 2.6.32
kernels.

But now, in 3.0, the modprobe command line parameter appears
to be ignored and the one specified on _kernel_ command
line takes precedence.

To me, it does not look right, I'd expect modprobe command
line to be "stronger" than kernel command line.

So, am I right that kernel command line has more "weight"
here, and if yes, why?

Thanks,

/mjt
