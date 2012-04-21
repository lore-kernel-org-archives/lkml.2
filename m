Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab2DUSOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 14:14:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53757 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2DUSOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:14:45 -0400
Message-ID: <4F92F910.60900@lwfinger.net>
Date: Sat, 21 Apr 2012 13:14:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: Missed Cc for stable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I missed a Cc for stable in this patch:

================================================
commit 2080913e017ab9f88379d93fd09546ad95faf87b
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Sat Feb 25 18:10:21 2012 -0600

     staging: r8712u: Fix regression caused by commit 8c213fa

     In commit 8c213fa "staging: r8712u: Use asynchronous firmware loading",
     the command to release the firmware was placed in the wrong routine.

     In combination with the bug introduced in commit a5ee652 "staging: r8712u:
     Interface-state not fully tracked", the driver attempts to upload firmware
     that had already been released. This bug is the source of one of the
     problems in https://bugs.archlinux.org/task/27996#comment89833.

     Tested-by: Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>
     Tested-by: Adrian <agib@gmx.de>
     Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
==============================================

Thanks,

Larry
