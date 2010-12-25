Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab0LYNNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 08:13:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39193 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0LYNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 08:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=N1sl/QHznnq4rJ+cZV5YoOw7aD68NNLKMGkAPu9wtscTPSgSkLf2ZNmG2TwVPjI6Bs
         kk527QDwHxmNOdNm44mEH4MIhc/VL1wCSVE3pZOb3lJgVPsTRffw+eLfgznUkny5V9Wb
         upbMF6hUNAmY2p5YKPk9XDD78Sl7eVqlvHwJ0=
Date: Sat, 25 Dec 2010 14:13:43 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [2.6.37-rc7] drivers/gpu/drm/drm_edid.c:1303: warning: array
 subscript is above array bounds
Message-ID: <20101225131343.GA1960@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
There is this compile warning in Linus' tree (gcc version 4.3.3):

drivers/gpu/drm/drm_edid.c: In function 'drm_detect_hdmi_monitor':
drivers/gpu/drm/drm_edid.c:1303: warning: array subscript is above array bounds
drivers/gpu/drm/drm_edid.c: In function 'drm_detect_monitor_audio':
drivers/gpu/drm/drm_edid.c:1303: warning: array subscript is above array bounds

Cheers,
Jarek P.
