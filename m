Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1J1PEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:04:52 -0400
Received: from c-adt-5.ataco.se ([213.115.168.248]:56513 "EHLO
	bixbite.inguza.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1J1PEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:04:51 -0400
X-Greylist: delayed 2452 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Oct 2011 11:04:51 EDT
Message-ID: <20111028162352.37494l492x5hbsow@webmail.inguza.net>
Date: Fri, 28 Oct 2011 16:23:52 +0200
From: "Ola Lundqvist" <ola@inguza.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: vnc-list@realvnc.com, linux-kernel@vger.kernel.org, ap@solarrain.com
Subject: RE: 3.x/libc6 -- out of ideas -- launching chrome results in an
	immediate crash of Xvnc everytime [SOLVED, well root cause found anyway]
References: <00d201cc9563$a94739a0$fbd5ace0$@lucidpixels.com>
In-Reply-To: <00d201cc9563$a94739a0$fbd5ace0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin

This is clearly a bug in VNC. Can you please report this problem separately.

Best regards,

// Ola

Quoting "Justin Piszcz" <jpiszcz@lucidpixels.com>:
> Hi,
>
> It came down to this Google Chrome extension:
>
> Name: Extensions Manager (aka switcher)
> Version: 0.1.6.95_0
>
> When this extension is enabled in 64-bit Linux when I launch Google Chrome
> on two separate machines (both 64-bit/Debian), it crashes Xvnc, when I
> disable/remove this extension, Xvnc no longer crashes (at least it has not
> yet :-))
>
> All of this hassle due to 1 bad plug-in; in any event though there is a bug
> in X/VNC, an application should not crash VNC.
>
> Just a heads up to anyone else who sees this problem.
>
> Justin.
>
>
>



-- 
  --- Inguza Technology AB --- MSc in Information Technology ----
/  ola@inguza.com                    Annebergsslingan 37        \
|  opal@debian.org                   654 65 KARLSTAD            |
|  http://inguza.com/                Mobile: +46 (0)70-332 1551 |
\  gpg/f.p.: 7090 A92B 18FE 7994 0C36 4FE4 18A1 B1CF 0FE5 3DD9  /
  ---------------------------------------------------------------
