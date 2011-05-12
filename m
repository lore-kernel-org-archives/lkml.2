Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab1ELTTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:19:14 -0400
Received: from mail.perches.com ([173.55.12.10]:1564 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab1ELTTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:19:12 -0400
From: Joe Perches <joe@perches.com>
To: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] sctp: socket cleanups
Date: Thu, 12 May 2011 12:19:08 -0700
Message-Id: <cover.1305227620.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Size trivially reduced as well.

$ size net/sctp/socket.o
   text	   data	    bss	    dec	    hex	filename
  55720	    442	  14988	  71150	  115ee	net/sctp/socket.o.new
  55730	    442	  14996	  71168	  11600	net/sctp/socket.o.old

Joe Perches (2):
  sctp: sctp_sendmsg: Don't initialize default_sinfo
  sctp: sctp_sendmsg: Don't test known non-null sinfo

 net/sctp/socket.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

-- 
1.7.5.rc3.dirty

