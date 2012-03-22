Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2CVIRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 04:17:05 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:34734 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab2CVIQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 04:16:58 -0400
Message-ID: <4F6ADFF8.5000106@yahoo.co.jp>
Date: Thu, 22 Mar 2012 17:16:56 +0900
From: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier
 Sil3726
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp>
In-Reply-To: <4F6AAC37.7040907@yahoo.co.jp>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my poor English.
And I used wrong mail address.

(2012/03/22 13:36), ANEZAKI, Akira wrote:
> 3.2.x kernel sometimes breaks metadata and I have to fix them. I feel it
> strange and cannot understand that the kernel sometimes breaks
> metadatas/superblocks of RAIDs/file systems those don't include any HDDs
> those don't connected to any PMP.
... the kernel sometimes breaks metadata/superblock of RAID/file system.
The kernel may break them even if those don't include a HDD that is
connected to a PMP.

is correct.

Akira
