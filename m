Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab1CPQDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:03:39 -0400
Received: from mx1.math.uh.edu ([129.7.128.32]:40461 "EHLO mx1.math.uh.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab1CPQDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:03:32 -0400
X-Greylist: delayed 3093 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Mar 2011 12:03:32 EDT
From: "Jason L Tibbitts III" <tibbs@math.uh.edu>
To: Eric Paris <eparis@parisplace.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, hughd@google.com, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: implement security.capability xattrs
References: <20110111210710.32348.1642.stgit@paris.rdu.redhat.com>
	<AANLkTi=wyaLP6gFmNxajp+HtYu3B9_KGf2o4BnYA+rwy@mail.gmail.com>
	<AANLkTi=7GyY=O2eTupPXQijcnT_55a3RnHAruJpm_5Jo@mail.gmail.com>
Date: Wed, 16 Mar 2011 10:11:38 -0500
In-Reply-To: <AANLkTi=7GyY=O2eTupPXQijcnT_55a3RnHAruJpm_5Jo@mail.gmail.com>
	(Eric Paris's message of "Wed, 2 Mar 2011 14:29:59 -0500")
Message-ID: <ufa7hbzje1h.fsf@epithumia.math.uh.edu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "EP" == Eric Paris <eparis@parisplace.org> writes:

EP> I know there exist thoughts on this patch somewhere on the
EP> internets. Let 'em rip!  I can handle it!

Well, I've been running it for a while (currently patched into Fedora
15's 2.6.38 package) in order to be able to init Fedora chroots in tmpfs
(for doing fast mock builds).  Seems to work fine for me.  Unfortunately
I'm not able to comment on the patch itself, which I guess is what it
really needs in order to make it upstream.

 - J<
