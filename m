Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab2DJPD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:03:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40940 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab2DJPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:03:27 -0400
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 17:03:26 +0200
X-Google-Sender-Auth: KV6JAyxyQuAjYqy0NawWIcuTFI0
Message-ID: <CACPM=kWa=UWuCMaYAtVMGJ7pzCy-PfyNRWBSuJnTZGtssU0W6g@mail.gmail.com>
Subject: via-rhine: Problem with lost link after a while
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Francois,

There seems to be a few problems with the new via-rhine driver.

After going to 3.3, it seems to drop link from time to time (randomly
it seems) - this didn't happen when I was running the patches from you
on top of 3.2 when we where testing them back in january.

It seems like other people have having a few problems too:
https://bugzilla.redhat.com/show_bug.cgi?id=805801 and on the
soekris-tech mailing list today (the archive hasn't been updated, so I
cannot post a link yet)

Got any ideas?

I'm ready to help testing if needed.

/Bjarke
