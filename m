Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab1IIUtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:49:03 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46052 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933838Ab1IIUtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:49:00 -0400
Date: Fri, 9 Sep 2011 22:48:54 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jesper Andersen <jespera@diku.dk>, Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Backporting the Linux kernel, for good - was: Re: semantic patch
 inference
In-Reply-To: <CAB=NE6U0ks9CobukO04=bZpnkm3Yw+Pf7keVPsP-hv1NyJZ_Xw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109092245170.9242@ask.diku.dk>
References: <CAB=NE6U0ks9CobukO04=bZpnkm3Yw+Pf7keVPsP-hv1NyJZ_Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your email.  It made me realize that there was one thing that I
didn't understand at all.  If the patches are only intended to apply to
linux-next, that makes the problem quite a bit simpler.  I guess that the
patch that spdiff will receive will already contain the appropriate #ifs,
so we don't have to be concerned about them.  We just add them in as is.

There was also the question about one or multiple types of changes.  I
think this is not a problem, but Jesper should confirm.  If a patch contains
two changes and one can be generalized and the other one cannot for some
reason, does spdiff give up on the whole thing, or does it do what it can?

Overall, the whole thing seems to be doable :)

julia
