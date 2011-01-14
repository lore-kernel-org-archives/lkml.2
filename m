Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab1ANPV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:21:58 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:54819 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab1ANPVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:21:53 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 14 Jan 2011 07:21:12 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Shawn Bohrer <shawn.bohrer@gmail.com>
cc: Jack Stone <jwjstone@fastmail.fm>,
        Andrew Morton <akpm@linux-foundation.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH resend] fs/eventpoll.c: fix compilation warning
In-Reply-To: <AANLkTikQwgzTZrTVQ_kfxwNdT-_8Ly5FjCxiXB2gxj3W@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101140720230.6262@localhost6.localdomain6>
References: <1295005953-12173-1-git-send-email-viresh.kumar@st.com> <4D304A84.1000601@fastmail.fm> <AANLkTikQwgzTZrTVQ_kfxwNdT-_8Ly5FjCxiXB2gxj3W@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Shawn Bohrer wrote:

> Yes timeout can be negative.  When timeout is negative it signifies an
> infinite timeout.  Therefore I think the correct fix is to initialize
> slack to 0.  I actually sent a patch to fix this back in November, but
> it looks like it was never applied.
> 
> https://lkml.org/lkml/2010/11/27/143
> 
> Andrew, can you apply this patch?  Let me know if I need to resend.

Yes, please.


- Davide


