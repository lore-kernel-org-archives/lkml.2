Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1GCUHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 16:07:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42660 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1GCUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 16:06:58 -0400
MIME-Version: 1.0
X-Originating-IP: [202.78.240.10]
In-Reply-To: <20110703191404.GL2544@shale.localdomain>
References: <1309667900-2225-1-git-send-email-chrisf@ijw.co.nz>
	<20110703191404.GL2544@shale.localdomain>
Date: Mon, 4 Jul 2011 08:06:57 +1200
Message-ID: <CAH3ygc0iLVu4oyEzf0P+uLGv8i_PFQhHm8MKT4bct+C+Di8Q-g@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: bcm: sort: kill handrolled bubblesort
From: Chris Forbes <chrisf@ijw.co.nz>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it has not been tested. I have checked that it builds cleanly and
passes checkpatch though.

-- Chris
