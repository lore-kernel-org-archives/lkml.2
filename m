Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1C2BJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 21:09:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61457 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1C2BJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 21:09:46 -0400
Message-ID: <4D9131FA.8080209@cn.fujitsu.com>
Date: Tue, 29 Mar 2011 09:12:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.39
References: <1301312919-sup-1222@think> <20110328132527.GM17108@twin.jikos.cz>
In-Reply-To: <20110328132527.GM17108@twin.jikos.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-29 09:08:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-29 09:08:14,
	Serialize complete at 2011-03-29 09:08:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Sterba wrote:
> Hi,
> 
> Chris, you did not add my sign-of on the unaligned fix I've posted, nor
> the tested-by or reported-by. Looking again into the mail, it seems like
> some automated-misprocessing picked the first part of the mail altough
> there was properly formated patch after '--' marker (and I've verified
> this is correct before sending the mail).
> 
> Can you please fix that?
> Patch reference: https://patchwork.kernel.org/patch/645671/
> 

It can't be fixed as Linus has pulled the tree. Fortunetely it's not a
big deal, and you are still recorded as the author of that patch. ;)
