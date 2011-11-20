Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1KTWec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 17:34:32 -0500
Received: from mx2.etf.rs ([147.91.14.170]:42689 "EHLO mx2.etf.bg.ac.rs"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab1KTWe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 17:34:28 -0500
X-Greylist: delayed 2087 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Nov 2011 17:34:28 EST
MIME-Version: 1.0
Reply-To: igorm@etf.rs
Date: Sun, 20 Nov 2011 22:59:29 +0100
Message-ID: <CAFdo_mWE8wMB6QJt_DPi9Ou9OiayzV48URDq7KhKf+q8OfP+Gw@mail.gmail.com>
Subject: MPLS for Linux kernel
From: =?ISO-8859-2?Q?Igor_Maravi=E6?= <igorm@etf.rs>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I've been working on implementation of MPLS for Linux kernel, for a
some time now.
I continued the work of James Leu
(https://sourceforge.net/projects/mpls-linux/) and used some fixes of
Jorge Boncompte
(http://mpls-linux.git.sourceforge.net/git/gitweb.cgi?p=mpls-linux/net-next;a=shortlog;h=refs/heads/net-next-mpls).

I fixed a lot of bugs, so now it can be compiled and run with all
Kernel Hacking options enabled.
My code could be found on this sites:

https://github.com/i-maravic/MPLS-Linux
https://github.com/i-maravic/iproute2

Any feedback is appreciated :)

On Dave's blog I read that MPLS is one of the things that should be
implemented in to the Linux kernel.
What is the procedure to do that with this code?
BR
Igor Maravić
