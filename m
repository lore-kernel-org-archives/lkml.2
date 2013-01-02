Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab3ABXBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:01:32 -0500
Received: from magic.merlins.org ([209.81.13.136]:54641 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3ABXBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:01:31 -0500
Date: Wed, 2 Jan 2013 15:01:28 -0800
From: Marc MERLIN <marc@merlins.org>
To: Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fairly reproduceable crash in 3.7.1 Null pointer
 rb_erase+0xc4/0x292
Message-ID: <20130102230128.GE8631@merlins.org>
References: <20130102222757.GC8631@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102222757.GC8631@merlins.org>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-Operating-System: Proudly running Linux 3.6.6-amd64-preempt-20120903/Debian
 wheezy/sid
X-Mailer: Some Outlooks can't quote properly without this header
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-No-Run: Yes
X-SA-Exim-Connect-IP: 82.235.219.215
X-SA-Exim-Mail-From: merlin@merlins.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 02:27:57PM -0800, Marc MERLIN wrote:
> Google only shows hits pointing to an ext4 patch that didn't go in 3.7
> proper.
> 
> http://marc.merlins.org/tmp/crash.jpg

Grumble, I kind of forgot to add the link to my .config, sorry about
that:
http://marc.merlins.org/tmp/.config-3.7.1-amd64-preempt-20121226

While my crash picture is lame (sorry), I'm happy to provide what else I
can before I go home and can provide a proper serial console crash dump.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
