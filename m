Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1IMUiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:38:04 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46150 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab1IMUiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:38:01 -0400
Message-ID: <4E6FBDAA.9010701@garzik.org>
Date: Tue, 13 Sep 2011 16:31:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linux IDE mailing list <linux-ide@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: libata-dev moved to github
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since k.org seems to be taking a while, libata-dev.git has moved to 
github:  git://github.com/jgarzik/libata-dev.git

The branch names remain the same:

NEXT - linux-next branch (hello Stephen, please pull this)

ALL - linux-next + any additional bits we want to test, that are not 
quite ready for NEXT.  Originally this was created for akpm's -mm tree, 
but I'm not sure he pulls this anymore.

upstream - queued for upstream, often equivalent to NEXT

upstream-fixes - fixes queued for upstream.  not used when merge window 
is open.  Typically pushed rapidly to Linus.  NOTE:  Does not exist yet 
at github, but will soon, when I merge a couple fixes later today.



