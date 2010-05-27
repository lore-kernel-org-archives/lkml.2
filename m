Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab0E0RL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:11:59 -0400
Received: from hera.amn.nl ([213.189.22.5]:1554 "EHLO AMN.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754371Ab0E0RL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:11:58 -0400
Message-ID: <4BFEA7CD.6020703@cs.vu.nl>
Date: Thu, 27 May 2010 19:11:41 +0200
From: Erik van der Kouwe <vdkouwe@cs.vu.nl>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Fam Zheng <famcool@gmail.com>
Subject: Re: [PATCH] fs/minix: bugfix, number of indirect block ptrs per block
 depends on block size
References: <4BFCF1EB.20709@cs.vu.nl> <20100526215442.GB3316@quack.suse.cz>
In-Reply-To: <20100526215442.GB3316@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
AMN-SPF: NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

>   Out of curiosity: Are you really using MINIX? The code is dead for a
> long time...

MINIX is very much alive, see http://www.minix3.org/.

I work in the team developing MINIX. Being able to exchange data between 
Linux and MINIX is very useful for us and there is no other filesystem 
that the two share. We have been aware of (and annoyed by) this problem 
for a long time, but didn't know the cause (and didn't have much time to 
check). Feiran is a GSoC student working on our project and he found the 
issue when setting up his development environment so then we decided to 
bring out a patch.

With kind regards,
Erik
