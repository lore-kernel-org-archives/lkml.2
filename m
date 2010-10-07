Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0JGUsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:48:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51891 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0JGUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=wzXEw2EBarLokJvP7SsTvuSrmpRyYOC9zpgFRlCx5zWXyF++CSX1jaZpR1+wPJfDg3
         yqDQKUztXMlKP7ywBeYnjB5shyFnwVZQcBpU/83oOGTIrXeZn4z4DxJV7To5wt2nJkM4
         tyPgYxpmG3JisGnMVszeHUUXcJzG5biWbiF6k=
MIME-Version: 1.0
In-Reply-To: <1286482013.23836.29.camel@c-dwalke-linux.qualcomm.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com>
 <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com> <AANLkTi=8Et=Z6zrzbZa3L0MO=cBjjh7L=XU2=PDEbzWW@mail.gmail.com>
 <1286481532.23836.27.camel@c-dwalke-linux.qualcomm.com> <AANLkTi=j2n-X+-zkas8HdL1awo7Lcyxwofts6FjU8vj6@mail.gmail.com>
 <1286482013.23836.29.camel@c-dwalke-linux.qualcomm.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 7 Oct 2010 16:47:59 -0400
X-Google-Sender-Auth: dhbSMEUfUw493hlcDKYEOBh0j0s
Message-ID: <AANLkTinDvL9vPb6nmve3rO9dMtMAqh=d1oqBVTOHzYWH@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 16:06, Daniel Walker wrote:
> On Thu, 2010-10-07 at 16:02 -0400, Mike Frysinger wrote:
>> how is that any different from:
>> ln -s ttyJ0 /dev/ttyS0
>
> It has the same major and minors as ttyS* does. So you don't have to run
> anything on the target.

i dont see how those things are related.  the major/minor are
irrelevant, unless you've already hard coded these in some app that
creates device nodes manually (instead of mdev/udev), but even then
that's something that "needs to be run on the target".  and both
already have config support to transparently do something like
"symlink ttyS# to XXX" as XXX is created.
-mike
