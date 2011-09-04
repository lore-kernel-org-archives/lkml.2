Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1IDQyl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 12:54:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57413 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1IDQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 12:54:34 -0400
Message-ID: <6fdb58aed1dae8020900e65cbfb34b28.squirrel@www.firstfloor.org>
In-Reply-To: <yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
    <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
    <20110902182214.GC12086@tux1.beaverton.ibm.com>
    <yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
Date: Sun, 4 Sep 2011 18:54:28 +0200
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
From: "Andi Kleen" <andi@firstfloor.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: djwong@us.ibm.com, "Greg Freemyer" <greg.freemyer@gmail.com>,
        "Andreas Dilger" <adilger.kernel@dilger.ca>,
        "Theodore Tso" <tytso@mit.edu>,
        "Sunil Mushran" <sunil.mushran@oracle.com>,
        "Amir Goldstein" <amir73il@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Andi Kleen" <andi@firstfloor.org>, "Mingming Cao" <cmm@us.ibm.com>,
        "Joel Becker" <jlbec@evilplan.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, "Coly Li" <colyli@gmail.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Westmere and beyond it is possible to accelerate generic CRC
> calculation using the PCLMULQDQ operation. There are many of our CRC

Faster than the lookup table? That's hard to believe.

-Andi

