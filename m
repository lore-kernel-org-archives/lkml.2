Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1IXRu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 13:50:58 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37839 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1IXRuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 13:50:55 -0400
Message-ID: <4E7E187B.4060507@gmail.com>
Date: Sat, 24 Sep 2011 19:50:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz> <20110922224653.GB21296@kroah.com> <4E7CD560.8010706@suse.cz> <20110923190840.GA31009@suse.de> <4E7CDC30.8070607@gmail.com> <20110923220440.GC30017@suse.de>
In-Reply-To: <20110923220440.GC30017@suse.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2011 12:04 AM, Greg KH wrote:
> On Fri, Sep 23, 2011 at 09:21:20PM +0200, Jiri Slaby wrote:
>> But if there are more trees depending on the tree, then OK, I will live
>> with that ;).
> 
> For the tty tree, I really doubt it, but I am not sure (rumor has it
> that some people are basing on it, but that might just be rumor.)

Ok, for the other uart patches I have, it would be convenient for me to
have the possibility of rebase. Would you mind if I add something like
uart-cleanup tree to the -next tree and will have the patches there
until I send them to you?

Just for the purpose of fine tuning (and rebasing) if something needs to
be fixed in them. The code is so complex, that I'm afraid I omitted some
semi-hidden dependency. And it would be great to fix patches like when I
used to work with the -mm tree.

thanks,
-- 
js
