Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab0L3IfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 03:35:23 -0500
Received: from vuizook.err.no ([85.19.221.46]:37944 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0L3IfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 03:35:22 -0500
X-Greylist: delayed 2175 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2010 03:35:22 EST
Date: Thu, 30 Dec 2010 08:59:01 +0100
From: Mike Hommey <mh@glandium.org>
To: linux-kernel@vger.kernel.org
Subject: Containers and /proc/sys/vm/drop_caches
Message-ID: <20101230075901.GA4115@glandium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: A479 A824 265C B2A5 FC54  8D1E DE4B DA2C 54FD 2A58
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that from within a lxc container, writing "3" to
/proc/sys/vm/drop_caches would flush the host page cache. That sounds a
little dangerous for VPS offerings that would be based on lxc, as in one
VPS instance root user could impact the overall performance of the host.
I don't know about other containers but I've been told openvz isn't
subject to this problem.
I only tested the current Debian Squeeze kernel, which is based on
2.6.32.27.

Cheers,

Mike
