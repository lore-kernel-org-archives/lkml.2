Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab1LXMCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 07:02:47 -0500
Received: from pal-213-228-181-48.netvisao.pt ([213.228.181.48]:55027 "EHLO
	smtp.decimal.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1LXMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 07:02:46 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Dec 2011 07:02:46 EST
From: "Jorge Bastos" <mysql.jorge@decimal.pt>
To: "'Jan Kara'" <jack@suse.cz>
Cc: <linux-kernel@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        <haiyangz@microsoft.com>, <hjanssen@microsoft.com>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt> <20111213180707.GI11747@quack.suse.cz>
In-Reply-To: <20111213180707.GI11747@quack.suse.cz>
Subject: RE: Reiserfs.c bug in 3.2-rc5
Date: Sat, 24 Dec 2011 11:55:43 -0000
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acy5wfSSX7s9dQ7LT+Ch0yz93/DxAgIZnOmw
Content-Language: pt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy,

> >
> > What can be done here?
>   The assertion failing is:
>         BUG_ON(nblocks > journal->j_trans_max);
> in do_journal_begin_r(). That means that reiserfs_create() tried to
> start a
> transaction with more credits than allowed by the journal.
> 
>   When did you started to see this problem? Also do you use SELinux (or
> generally security labels)?
> 

No SELinux, the only change is from 3.1.1 to 3.2-rc5.
Tried the new 3.2-rc7 and the problem persists.

Is there a way that the ReiserFS people can commit the fix?

Jorge,

