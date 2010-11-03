Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab0KCPfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:35:41 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:37556 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932412Ab0KCPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:31:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hbE4becVM1luZsECGqnGvnNl6ANxo6HFACTDma9pgIP9WsW
 SD8hSH30jIk_CFgIS.BIaUDGOHbtEc9KkXmqVuev.FJ2QFdCfjFzijdVmUq8
 2EWu6SvqLm1K8KnyLDIUL9FCHOTMCjw03GBzRL_EyaWuVWjslXXlgqRrgedE
 iAkaS4t3PR_M.haM._vvumDk.q4gKkZd6gzoRzkXE2HoIpM87TwF5Njc4u7v
 KlpDiGcwL7G8xcWk6fHi5awm1BC87M1Ylx7YiRxXkng--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 3 Nov 2010 10:31:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: jovi zhang <bookjovi@gmail.com>
cc: Jesper Juhl <jj@chaosbits.net>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
In-Reply-To: <AANLkTinhAQ7mNQWtjWCOWEHHwgUf+BynMM7jnVBMG32-@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011031030150.11625@router.home>
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net> <AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com> <20101031173336.GA28141@balbir.in.ibm.com> <alpine.LNX.2.00.1011010639410.31190@swampdragon.chaosbits.net>
 <alpine.DEB.2.00.1011030937580.10599@router.home> <AANLkTinhAQ7mNQWtjWCOWEHHwgUf+BynMM7jnVBMG32-@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010, jovi zhang wrote:

> On Wed, Nov 3, 2010 at 10:38 PM, Christoph Lameter <cl@linux.com> wrote:
> > Could we avoid this painful exercise with a "semantic patch"?

> Can we make a grep script to walk all files to find vzalloc usage like this?
> No need to send patch mail one by one like this.

Please use spatch. See http://lwn.net/Articles/315686/
