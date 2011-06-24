Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab1FXBIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 21:08:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48187 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760020Ab1FXBIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 21:08:36 -0400
Date: Fri, 24 Jun 2011 03:08:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Craig Bergstrom <craigb@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Stefan Assmann <sassmann@kpanic.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "rick@vanrein.org" <rick@vanrein.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-ID: <20110624010835.GQ3263@one.firstfloor.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de> <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de> <20110623170014.GN3263@one.firstfloor.org> <987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com> <BANLkTikTTCU3eKkCtrbLbtpLJtksehyEMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikTTCU3eKkCtrbLbtpLJtksehyEMg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We (Google) are working on a data-driven answer for this question.  I know
> that there has been some analysis on this topic on the past, but I don't
> want to speculate until we've had some time to put all the pieces together.
>  Stay tuned for specifics.

It would be also good if you posted your kernel patches.

It's highly unusual -- to say the least -- to let someone's openly
developed and posted patchkit compete with someone's else secret 
internal solution for review purposes.

-Andi
