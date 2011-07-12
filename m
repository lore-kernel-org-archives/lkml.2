Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab1GLG3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:29:49 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:46648 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab1GLG3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:29:48 -0400
X-ASG-Debug-ID: 1310452184-01de280c1ebf210001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E1BE9D4.7020006@fusionio.com>
Date: Tue, 12 Jul 2011 08:29:40 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "jeffm@suse.de" <jeffm@suse.de>, "tytso@google.com" <tytso@google.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] fixlet: Remove fs_excl from struct task.
References: <1308949107-1962-1-git-send-email-teravest@google.com> <20110624220240.GA6455@infradead.org> <CAN5ZDdfVEvxgwmRPwMVSq7iqTTaQ5fi5A-qtCsiqzTRjhOuL+A@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH] fixlet: Remove fs_excl from struct task.
In-Reply-To: <CAN5ZDdfVEvxgwmRPwMVSq7iqTTaQ5fi5A-qtCsiqzTRjhOuL+A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310452184
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68679
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-11 22:44, Justin TerAvest wrote:
> Jens,
> 
> Have you had a chance to look at this? Christoph mentioned you'd
> wanted to keep this,
> but the last discussion I see is from 2009 and it doesn't look like
> much has happened since then.

Lets kill it! I'm pulling your patch into the 3.1 core branch.

-- 
Jens Axboe

