Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2CLW0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:26:24 -0400
Received: from serv04.lahn.de ([213.239.197.57]:38086 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757704Ab2CLW0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:26:23 -0400
Date: Mon, 12 Mar 2012 23:25:16 +0100
From: lkml20120218@newton.leun.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        James Hogan <james@albanarts.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Starr <shawn.starr@rogers.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Available fix for 3.3 regression Bug #42822 not yet in mainine (Fw:
 [GIT PULL FOR v3.3] uvcvideo divide by 0 fix)
Message-ID: <20120312232516.2350ddd3@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

unfortunately the patch mentioned in the forwarded mail below seems not
to be in mainline yet.

Fixes [Bug #42822] [3.3.0-rc3][uvcvideo][regression] oops -
uvc_video_clock_update, see
http://marc.info/?l=linux-kernel&m=132970057611642&w=2



Start weitergeleitete Nachricht:

Datum: Mon, 20 Feb 2012 12:49:39 +0100
Von: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
An: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
linux-media@vger.kernel.org,        linux-kernel@vger.kernel.org
Betreff: [GIT PULL FOR v3.3] uvcvideo divide by 0 fix


Hi Mauro,

The following changes since commit
b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

The patch fixes a divide by 0 bug reported by a couple of users
already. Could you please make sure it gets into v3.3 ?

Laurent Pinchart (1):
      uvcvideo: Avoid division by 0 in timestamp calculation

 drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

--
Regards,

Laurent Pinchart

-- 
MfG,

Michael Leun

