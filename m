Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1GWR12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 13:27:28 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58939 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753136Ab1GWR1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 13:27:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GGQPHSdRk4MJ9raSVI2AnjZ5VzpkbV8l/mnEC9tlTaaAWDuzboL1t16smv+qlcgfNPOI2f07y2/uPciGtQS36ZDBN0xasIxQLP8ffBOtP7DqHzNZ32OY1RK/7Bzpp5bJ;
Date: Sat, 23 Jul 2011 10:27:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] First round of SCSI updates for 2.6.39 merge window
Message-Id: <20110723102719.a7f26008.rdunlap@xenotime.net>
In-Reply-To: <1311441452.23720.17.camel@mulgrave>
References: <1311441452.23720.17.camel@mulgrave>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011 21:17:32 +0400 James Bottomley wrote:

> This represents the usual round of driver updates (fcoe, bfa, mpt2sas,
> iscsi, bnx2fc) plus a couple of fixes that didn't make 3.0 including the
> USB force eject oops.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

Hi James,

(please fix $subject)


What has happened to these 2 patches from 2011-June-21 ?

Subject: [PATCH] scsi: fix NCR_Q720 section mismatch warning
Subject: [PATCH] scsi: fix sim710 section mismatch warnings


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
