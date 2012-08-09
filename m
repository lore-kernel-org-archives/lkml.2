Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab2HITbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:31:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43172 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223Ab2HITbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:31:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6X4JQmQgtgcy9is0hn0nNypTKJN-d2RHFR7vvg=vO_eHQ@mail.gmail.com>
References: <6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
 <1344485382.2024.9.camel@joe2Laptop> <6349D7A510622448B1BA0967850A843801369364@NASANEXD02D.na.qualcomm.com>
 <20120808.231804.12694947300243733.davem@davemloft.net> <6349D7A510622448B1BA0967850A8438013693DD@NASANEXD02D.na.qualcomm.com>
 <20120809145454.GA21195@home.goodmis.org> <1344525758.3165.8.camel@joe2Laptop>
 <1344526098.6935.44.camel@gandalf.stny.rr.com> <CAB=NE6X4JQmQgtgcy9is0hn0nNypTKJN-d2RHFR7vvg=vO_eHQ@mail.gmail.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 9 Aug 2012 12:31:01 -0700
X-Google-Sender-Auth: 7dEHIOt6ovhIGC3cwhEjyA45Is4
Message-ID: <CAB=NE6V5trmCP+PL3wmOsaVmN1whoiCa=K9EWY7z57mYMKrp2A@mail.gmail.com>
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joe Perches <joe@perches.com>, "Ren, Cloud" <cjren@qca.qualcomm.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "hao-ran.liu@canonical.com" <hao-ran.liu@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 12:13 PM, Luis R. Rodriguez
<rodrigue@qca.qualcomm.com> wrote:
> So -- are we OK to *not* include SOBs of evolutions sent to developers
> of joojoo-1 when company x submits joojoo-2 so long as those patches
> were sent publicly or a record is kept somewhere ?

And lets be fair, some folks *may* want their SOB passed along to the
second joojoo-2, its hard to please everyone but so long as we can
decide on a method -- then great, we don't have to come back to this
again and then we can add this as documentation. I'm inclined to
prefer to not have the small patch submitters SOB tag if their patch
to joojoo-1 was public and in it they did have a SOB tag, given that
in practice *a few* secondary patch submitters tend to get surprised
when their SOB is added to a secondary patch submission if they only
contributed a few lines. To be clear the SOB does not have anything to
do with how many lines you contributed, its meaning is here:

http://gerrit.googlecode.com/svn-history/r1526/documentation/2.1.2/user-signedoffby.html

So even if those secondary patch submitters *think* it has to do with
volume of code, perhaps its best in practice to not include them so
long as we have a record of the original small patch submission
publicly and with a SOB tag.

  Luis
