Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0FTVto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 17:49:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52293 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab0FTVtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 17:49:42 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 23:48:43 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/8] firewire: cdev ABI updates
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.00116e4425f35b7c@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Jun, Stefan Richter wrote:
> Following as replies:  Proposed updates to the <linux/firewire-cdev.h>
> ABI and to its backing implementation.  These updates are required for
> target-type userspace drivers and in order to be able to use more than
> one audio device with FFADO.
> 
> Some of the patches have already been seen on linux1394-devel but not
> yet on linux-kernel.
> 
> Corresponding patches to libraw1394 will be posted to linux1394-devel
> right after the kernel patch postings.

The patches have been committed to a temporary branch called "testing"
at the firewire drivers development repository:

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git testing

    gitweb:
    http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=shortlog;h=refs/heads/testing

This branch may be rebuild or deleted in case of negative feedback about
the proposed patches.

The patches are also available as quilt series and combo patches in my
backports to a few stable kernel series at

    http://user.in-berlin.de/~s5r6/linux1394/updates/

The corresponding libraw1394 patches are available at the libraw1394
mirror repository, also in a "testing" branch:

    git://git.kernel.org/pub/scm/libs/ieee1394/libraw1394.git testing

    gitweb:
    http://git.kernel.org/?p=libs/ieee1394/libraw1394.git;a=shortlog;h=refs/heads/testing

Would be good if a FFADO developer with two or more audio devices could
give this a run.
-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

