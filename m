Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2BFSTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:19:51 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:48551 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750797Ab2BFSTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:19:50 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5pQxkjYVM1lIXClNyDpp9sIyeRwrVqDjFD5dlpTySS.qNdO
 bP6ipK4bySqK2d7DlBAIo83uydQf.Z1nBajXcBWHMCrruB0BD.6zG2r2BsAp
 FQKvcj4UNq45SVplfDVg2RpYjJTC7Qn0SRx08HZeIMv2LFP3RFly7zo0TTuI
 KApHTVQy.MtWCc.qCOBFRfcl6u5br_4QbhxtCN6A5_wOak7AjKxXh46P3_11
 Wu6uSERLOPLSAO6ML32LKWHptXoiRnzZki1IW3swAQ_WqVWEAYvAcvjeWVXK
 xMzSse7Pl_4FuqOpwNrBjSxf5OXbDLVdqrnHb0cMh7bdQmK20Nid9se_6ZIu
 s3hF2N7DUOlBtBsdjHt75e9TUKJmGpzXP9qLEjLhRhLuaGB.7ka2bab7ziec
 XIA.mv3pUD4.4ZoWPkQpPys9eI8dpDIDvSsoz3akdygce.63Trcbm9rf9LBY
 9YmpnTabpkD5XucksCQvzfJUa8aF4gJ0-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 6 Feb 2012 12:19:44 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
In-Reply-To: <CAOtvUMdCZpQuSvutKHpMxthktTm_VkA1R99yxpNhxpsYN9wTRQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1202061218420.2799@router.home>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com> <1327591185.2446.102.camel@twins> <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com> <1328117722.2446.262.camel@twins> <20120201184045.GG2382@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202011404500.2074@router.home> <20120201201336.GI2382@linux.vnet.ibm.com> <4F2A58A1.90800@redhat.com> <20120202153437.GD2518@linux.vnet.ibm.com> <4F2AB66C.2030309@redhat.com> <20120202170134.GM2518@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202021124520.6338@router.home> <CAOtvUMdCZpQuSvutKHpMxthktTm_VkA1R99yxpNhxpsYN9wTRQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Feb 2012, Gilad Ben-Yossef wrote

>
> Frederic has the latest version in a git tree here:
>
> git://github.com/fweisbec/linux-dynticks.git
>        nohz/cpuset-v2-pre-20120117
>
> It's on top latest rcu/core.

Hmmm.. A pull vs upstream leads to lots of conflicts.


> But the good news is that with these hacks applied I managed to run a 100%
> CPU task  with  zero interrupts  (ticks or  otherwise) on an isolated cpu.

Cool.

> Disregarding TLB overhead, you get bare metal performance with Linux user
> space manageability and  debug capabilities.  Pretty magical really: It's like
> eating your cake and having it too :-)

We definitely need that.

