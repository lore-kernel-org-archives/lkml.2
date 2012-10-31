Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2JaBif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 21:38:35 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:49437 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab2JaBid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 21:38:33 -0400
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 21:38:33 EDT
Date: Wed, 31 Oct 2012 01:12:44 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Subject: Console font corruption on tty1 after using xorg in 3.6 with i915 
Message-ID: <20121031011244.GA14804@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=AUhbpHVS+xhHrj9wLCYAQoYnFLYUZdbP8UM0GmH2jwk= c=1 sm=0 a=wom5GMh1gUkA:10 a=JoKJUd9NJSQA:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=NCIGvu0kO5pZwXIYr-MA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, since 3.6-rc7 I'm *sometimes* seeing console font corruption on
tty1 after I leave xorg [ I'm old enough to use 'startx' ].  This is
with a 512-glyph font.  What seems to be happening is that many
lower-case ASCII letters, and also '0', are replaced by other
glyphs.  Many of these other glyphs happen to be stored at ASCII
values below 'space' in my font, but I doubt that is important.

 Last week I tried to determine where/when this happened, and
managed to get it by using the 3.4 epiphany browser, perhaps only
when accessing googlemail.  But it didn't happen all the time.  I
never saw it with 3.6-rc3, but I did see it with all of -rc7, 3.6.0,
3.6.1.  I then upgraded to 3.6.3 and the problem seemed to have gone.
Unfortunately, tonight it happened again in 3.6.3.

 Is anyone else seeing anything like this ?

 Just to be clear, I normally log in on tty1.  If the problem
occurs, tty2 to tty6 are fine.  The only way I've found to fix the
corruption is to reboot.  I'm mentioning i915 in the subject because
my r600 radeon doesn't have this problem.

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
