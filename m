Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab2CEWhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:37:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38895 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757175Ab2CEWht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:37:49 -0500
Date: Mon, 5 Mar 2012 16:37:45 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
Message-ID: <20120305223745.GC16312@ubuntu-macmini>
Mail-Followup-To: Josh Boyer <jwboyer@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
 <1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
 <20120305220651.GB16312@ubuntu-macmini>
 <CA+5PVA5nRvtDPXgen5=10=Yt2YdQAUo-K+OK8MXENiQ7wEQCYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5nRvtDPXgen5=10=Yt2YdQAUo-K+OK8MXENiQ7wEQCYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 05:10:50PM -0500, Josh Boyer wrote:
> On Mon, Mar 5, 2012 at 5:06 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > On Wed, Feb 22, 2012 at 08:37:37AM -0600, Seth Forshee wrote:
> >> Apple laptops with hybrid graphics have a device named gmux that
> >> controls the muxing of the LVDS panel between the GPUs as well as screen
> >> brightness. This driver adds support for the gmux device. Only backlight
> >> control is supported initially.
> >>
> >> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> >
> > Ping. Is there anything that would prevent getting this into 3.4?
> 
> I sent a list of patches that seemed ready for 3.4 to Matthew last week.  This
> was on the list and he seemed to agree.  I would guess he just either needs
> a minion, a clone, or a time machine.  Or maybe all three.

Huh, guess I missed that, and even now I can't seem to find it. Any
chance you could point me to the list?

Thanks for the heads-up!

Seth

