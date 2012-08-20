Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2HTI0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:26:46 -0400
Received: from plane.gmane.org ([80.91.229.3]:45762 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab2HTI0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:26:40 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Re: [ 00/46] 3.5.3-stable review
Date: Mon, 20 Aug 2012 10:26:25 +0200
Organization: The Fists of the White Lotus
Message-ID: <pan.2012.08.20.08.26.25.90194@googlemail.com>
References: <20120820035832.274275502@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5086a976.dip.t-dialin.net
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC: J. Bruce Fields)

Greg,

it looks like a fix for a regression in NFS is not mentioned in this
patch even though it was supposedly sent to -stable:
http://lkml.indiana.edu/hypermail/linux/kernel/1208.2/00594.html

I tried to locate the patch in git but could not find it anywhere. As far
as I can tell the fix works; in my case I noticed repeatable hangs when
trying to "move files to the trash" in XFCE and these hangs are now gone.
Have not noticed any negative side effects either.

thanks
Holger


