Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab1IBJjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:39:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52751 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab1IBJjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:39:46 -0400
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jon Mason <mason@myri.com>
Cc: scameron@beardog.cce.hp.com, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
In-Reply-To: <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	 <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110901160724.GN9189@beardog.cce.hp.com>
	 <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com>
	 <1314903038.3067.27.camel@dabdike>
	 <20110901125938.7cb1da85@jbarnes-desktop>
	 <20110901200349.GO9189@beardog.cce.hp.com>
	 <20110901130930.5caec2d4@jbarnes-desktop>
	 <20110901204419.GY8422@beardog.cce.hp.com>
	 <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 11:39:48 +0200
Message-ID: <1314956388.2573.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 01 septembre 2011 à 16:50 -0500, Jon Mason a écrit :

> I believe modifying the MRRS values is what is causing the issues.
> Can you try the attached patch and verify that it also resolves the
> issue?

I tested this patch and can confirm this solves the corruption problem.

But my disk is _much_ slower than before

# hdparm -t /dev/sda1

Before :

 Timing buffered disk reads: 254 MB in  3.02 seconds =  84.16 MB/sec

After :

 Timing buffered disk reads: 120 MB in  3.04 seconds =  39.42 MB/sec






