Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab1EMJUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:20:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:48804 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078Ab1EMJUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:20:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: patch from intel-drm-staging for 2.6.39
Date: Fri, 13 May 2011 09:19:53 +0000 (UTC)
Message-ID: <iqit3p$oka$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: artipc9.vub.ac.be
User-Agent: Pan/0.133 (House of Butterflies)
Cc: dri-devel@lists.freedesktop.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit from intel-drm-staging fixes an oops for me when docking my 
system. Can it be added to 2.6.39?

commit c60001b9921a869c7dc916e72a22c5805cc562ae
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Apr 22 10:47:08 2011 +0100

    drm: Take lock around probes for drm_fb_helper_hotplug_event

-- 
Frederik Himpe

