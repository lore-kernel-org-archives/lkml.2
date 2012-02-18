Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab2BRSfC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 13:35:02 -0500
Received: from serv04.lahn.de ([213.239.197.57]:54521 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab2BRSe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 13:34:59 -0500
X-Greylist: delayed 1907 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Feb 2012 13:34:59 EST
Date: Sat, 18 Feb 2012 18:54:19 +0100
From: Michael Leun <lkml20120218@newton.leun.net>
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
        senthilb@qca.qualcomm.com, linux-kernel@vger.kernel.org
Subject: Cannot put ath9k interface to different namespace?
Message-ID: <20120218185419.79376027@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

tried to put ath9k_htc interface to namespace, does not work:

jill:/home/ml # ip link set netns 4001 dev wlan3
RTNETLINK answers: Invalid argument

Also does not work with ath9k, but does work with other wlan devices
(tried zd1201, r8712u, thats what I've here at the moment).

When trying, device was down.

Is there some trick to do it or is there some support from driver for
that missing?

Any plans to fix that? Would that be big effort?

Thanks.

-- 
MfG,

Michael Leun

