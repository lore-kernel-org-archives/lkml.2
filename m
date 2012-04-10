Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab2DJVam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 17:30:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50812 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354Ab2DJVal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 17:30:41 -0400
MIME-Version: 1.0
Date: Tue, 10 Apr 2012 23:30:40 +0200
Message-ID: <CACPM=kXvq9eJj19MMW-G3hu4Qro_Z53YKWhxN24YqGFX6706kQ@mail.gmail.com>
Subject: p54: Weird error in log
From: Bjarke Istrup Pedersen <gurligebis@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I keep getting this error in my dmesg log:

p54pci 0000:00:0e.0: rx'd frame size exceeds length threshold

The p54 card is bridged together with two via-rhine network cards, to
create an access point.

The card seems to work fine - it is just that this message floods the
logs - I could comment it out in the driver, but it would make more
sense to figure out if it is a bug that causes it to get hit, or a
configuration issue.

Any ideas?

/Bjarke
