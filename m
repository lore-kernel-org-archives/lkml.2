Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0DBRny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:43:54 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:63922 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0DBRnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=RC6NgZ6GsiSTqyIyphrqie7GnQOf0FjIyoo2NeqOV6UOySPN6zzSuSfLckzw3sxx4k
         G1CP1yJbnrCgrkNYR2yWTdLFVGpUnSfpLR5xOKTzHInmBbzfuJrHpCueNBIrkjQemFj1
         CeDuhIQ/D3+CGIV9ecV5y8po7WtIvhWGXLfuQ=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 2 Apr 2010 10:36:34 -0700
Message-ID: <j2m43e72e891004021036j8304f62byc2ec08415b3e6ce7@mail.gmail.com>
Subject: Pending patches for 802.11 not marked stable or which requires a 
	manual backport
To: Greg KH <greg@kroah.com>, "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       stable-review@linux.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no coincidence that the 802.11 subsystem now has had no
regressions for 2.6.33 and 2.6.34 (thanks to Rafael for keeping track
of these). I don't think its that we haven't been doing a lot of
development, instead I think a lot of it has to do with the fact that
we have been aggressively engaged with stable after we were slapped
about this at our last wireless summit. There's a few patches which I
realize still do fall through the crack or due to time we haven't yet
backported. I have been subscribed the stable-review list [1] for a
few kernel releases and I think the process for review for stable is a
bit overwhelming and I can only thank you so much for the great work
you guys do at juggling all these patches together.

The main reason I see some patches still fall through the cracks is
due to some patches not being marked stable on the commit log entry or
the patch requiring some manual backport for the latest stable or for
other older stable series. To aid with this for the 802.11 subsystem
I've created a wiki page we can use for this purpose:

http://wireless.kernel.org/en/developers/stable-pending

If you are either a user or developer and you feel a patch is
important for stable which meet the above criteria please be sure to
mark it there. Help with manual backports are also appreciated as we
sometimes cannot address these due to time.

[1] http://linux.kernel.org/mailman/listinfo/stable-review

 Luis
