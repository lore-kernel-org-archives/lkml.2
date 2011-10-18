Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1JRIWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:22:16 -0400
Received: from a.relay.invitel.net ([62.77.203.3]:60116 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1JRIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:22:15 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Oct 2011 04:22:15 EDT
Date: Tue, 18 Oct 2011 10:11:59 +0200
From: =?iso-8859-1?B?R+Fib3IgTOlu4XJ0?= <lgb@lgb.hu>
To: linux-kernel@vger.kernel.org
Subject: barrier-based sync failed - disabling barriers
Message-ID: <20111018081159.GA21728@vega.lgb.hu>
Reply-To: lgb@lgb.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: vega Linux 2.6.38-12-generic i686
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have a kernel log entry I've never seen before:

JBD: barrier-based sync failed on cciss!c0d0p3-8 - disabling barriers
JBD: barrier-based sync failed on cciss!c0d0p1-8 - disabling barriers

Should I worry? Can it be blamed for the poor I/O performance? How can I
solve this problem? Even if it doesn't mean too much (what I should
worry about), it's a bit annoying (as always) to see odd messages.

The ext4 filesystems were created by the installer of an older (ubuntu)
distribution, I guess, it can cause problems after the upgrade. Can I
convert/modify the filesystem (like with tune2fs) not to have these messages
and problem?

Thanks a lot in advance for anyone who has some suggestion.

Regards,

Gábor Lénárt
