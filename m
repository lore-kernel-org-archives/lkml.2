Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1EJITJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:19:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:50919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932340Ab1EJITG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:19:06 -0400
Date: Tue, 10 May 2011 10:19:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Neil Brown <neilb@suse.de>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH][Trivial] md, raid5: Fix spelling error in comment
 ('Ofcourse' --> 'Of course').
In-Reply-To: <alpine.LNX.2.00.1104101757100.17454@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1105101018441.28291@pobox.suse.cz>
References: <alpine.LNX.2.00.1104101757100.17454@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Apr 2011, Jesper Juhl wrote:

> There's a small typo in a comment in drivers/md/raid5.c - 'Of course' is 
> misspelled as 'Ofcourse'. This patch fixes the spelling error.

Doesn't seem to be present in linux-next as of today. I have picked it up.

-- 
Jiri Kosina
SUSE Labs
