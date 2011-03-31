Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1CaCeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:34:06 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:49741 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab1CaCeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:34:04 -0400
Date: Wed, 30 Mar 2011 21:33:27 -0500
From: David Fries <David@fries.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fixed [Bug #16221] 2.6.35-rc2-git5 -- [drm:drm_mode_getfb]
 *ERROR* invalid framebuffer id
Message-ID: <20110331023327.GA6083@spacedout.fries.net>
References: <1SnkuNVk0vO.A.E9E.Qx1uMB@chimera>
 <u4vap2zcaSM.A._7G.p11uMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u4vap2zcaSM.A._7G.p11uMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Mar 2011 21:33:29 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 10:53:34PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16221
> Subject		: 2.6.35-rc2-git5 -- [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
> Submitter	: Miles Lane <miles.lane@gmail.com>
> Date		: 2010-06-11 20:31 (129 days old)
> Message-ID	: <AANLkTim0jVRyqkwlGOcrg_XTvUQwcBYfWJX-aRzkkrLG@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127628828119623&w=2

The patch to address this bug has been released in 2.6.38.  Can
you flag this report as closed and fixed?

commit 3ce05168907c9b1358492a73badb0ff1603fb81d
Author: David Fries <david@fries.net>  2010-12-12 12:39:22
Committer: Dave Airlie <airlied@redhat.com>  2010-12-20 21:00:04
Precedes: v2.6.38-rc1

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
