Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab0JVTKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:10:13 -0400
Received: from claw.goop.org ([74.207.240.146]:36169 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757661Ab0JVTKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:10:08 -0400
Message-ID: <4CC1E18E.9040502@goop.org>
Date: Fri, 22 Oct 2010 12:10:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gianluca Guida <gianluca.guida@citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen tree with the tip tree
References: <20101022140335.c4a3a48f.sfr@canb.auug.org.au>
In-Reply-To: <20101022140335.c4a3a48f.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/21/2010 08:03 PM, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the xen tree got a conflict in
> arch/x86/mm/init_32.c between commit
> 1d931264af0f10649b35afa8fbd2e169da51ac08 ("x86-32, memblock: Make
> add_highpages honor early reserved ranges") from the tip tree and commit
> 07147a06ac3b1b028124ea00ba44e69eb8ea7685 ("x86/32: honor reservations of
> high memory") from the xen tree.

Hm, that change has been completely obsoleted by the memblock stuff from
tip.  Oh, I see.  Another change which ended up reverting that patch via
a merge got dropped, so it got left lying around.  I'll pull it out.

(Not sure why it merges cleanly for me however; I guess because you've
already got the older xen branch in there which contains the merge.)

Anyway, update pushed.

    J
