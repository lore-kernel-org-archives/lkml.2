Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860Ab2JLQhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:37:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846Ab2JLQhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:37:38 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Staging: winbond: Fixed coding style issues
Date: Fri, 12 Oct 2012 22:07:06 +0530
Message-Id: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


winbond directory files have lots of coding style issues. The patch set tries to remove *most* (if not all) of the coding style issues. checkpatch.pl script is still complaining (like 80 characters limit) but major part of the serious coding style issues have been rectified. 
