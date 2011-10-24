Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab1JXR2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:28:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39827 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab1JXR2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:28:53 -0400
Date: Mon, 24 Oct 2011 12:28:42 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        eparis@redhat.com
Subject: Re: [PATCH 05/10] user namespace: clamp down users of cap_raised
Message-ID: <20111024172842.GA13556@sergelap>
References: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
 <1318974898-21431-1-git-send-email-serge@hallyn.com>
 <1318974898-21431-6-git-send-email-serge@hallyn.com>
 <14652.1319014868@redhat.com>
 <20111024144334.GA26603@hallyn.com>
 <CALQRfL4zCbzr_Fa0ySi96j06nw7ifocCxUjYUs6vXxeNvjCutQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALQRfL4zCbzr_Fa0ySi96j06nw7ifocCxUjYUs6vXxeNvjCutQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> Serge,
> 
> It seems as if this whole thing is really idiomatic. How about?
> 
> #define IN_ROOT_USER_NS_CAPABLE(cap)  \
>    ((current_user_ns() == &init_user_ns) && cap_raised(current_cap(), cap))

My objection to this was that it seems to encourage others to use it :)  I'm
not sure we want that.  Also, IN_ROOT_USER_NS seems more generally useful.

But if I'm the only one who feels this way I'll go ahead and do it...

thanks,
-serge
