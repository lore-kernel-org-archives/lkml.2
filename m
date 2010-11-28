Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0K1MV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 07:21:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42697 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0K1MVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 07:21:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ATFTWqRodxYZDbw0lmmMDYWxlUk76zRRVxmRADz9qlMmHfd9kVC76IbHXPPT+Lvi7I
         nDjWbNZes4sX+Nn0TI25KaSte1QJZhoKvlFuDU8jHyK1FXVpLOjGsVusBzK+k7TqlO/f
         7MsA+LVzcyvOCmhNgoHmhCQ8bS4XU64BEo5kI=
MIME-Version: 1.0
Date: Sun, 28 Nov 2010 14:21:24 +0200
Message-ID: <AANLkTimjMR4wUYCfi7BoUcg6aBmuWcQW_dBo8svReWcS@mail.gmail.com>
Subject: 2.6.37-rc3-git4 bad desktop performance
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Last known good kernel: 2.6.37-rc3
Driver: nouveau
Test: play a HD movie.
