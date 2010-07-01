Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab0GATcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:32:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58620 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0GATcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=M2DxP3VILWh3/FNwWcSSicuBtwZ/SQvDmD4i+xqo+Bu+GW/OHjVI4X9vGQYD4TTAXA
         U4XF+4t0/ZnzIf9NlPgU1R13LpqSicsbmZ2ijuR/w+dmSLN+63JXJRwAVTbI6LiPGmdA
         hXW+cXGz35ZoWeid0/BftaIV3nQoaWIjcEX9Y=
MIME-Version: 1.0
Date: Thu, 1 Jul 2010 13:31:59 -0600
Message-ID: <AANLkTil2nQ8MjccnMv6X6nQF3joAuhvl28xLUGDK3WJa@mail.gmail.com>
Subject: [ANNOUNCE] Open Cworthy Libraries 07-01-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://cworthylinux.googlecode.com/files/cworthy-07-01-2010.tar.gz

FIXES
- add restore_screen() to allow users to hit the space bar to repaint
the ncurses display in the event
a system error message gets written to the screen not trapped by stderr.
