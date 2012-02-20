Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2BTLtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:49:47 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:59361 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2BTLtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:49:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL FOR v3.3] uvcvideo divide by 0 fix
Date: Mon, 20 Feb 2012 12:49:39 +0100
Message-ID: <1689974.qoel1Ujv1I@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.0; x86_64; ; )
In-Reply-To: <20120219234151.GA32005@balrog>
References: <20120219234151.GA32005@balrog>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

The patch fixes a divide by 0 bug reported by a couple of users already. Could 
you please make sure it gets into v3.3 ?

Laurent Pinchart (1):
      uvcvideo: Avoid division by 0 in timestamp calculation

 drivers/media/video/uvc/uvc_video.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart
