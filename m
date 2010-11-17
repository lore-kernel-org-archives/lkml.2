Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883Ab0KQVS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:18:58 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41796 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933693Ab0KQVS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:18:57 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
Date: Wed, 17 Nov 2010 22:18:34 +0100
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>, Hugh Dickins <hughd@google.com>
References: <201011171139.33398.linux@rainbow-software.org> <20101117130422.d9de48d8.akpm@linux-foundation.org> <201011172212.01433.rjw@sisk.pl>
In-Reply-To: <201011172212.01433.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011172218.42053.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 November 2010 22:12:01 Rafael J. Wysocki wrote:
> On Wednesday, November 17, 2010, Andrew Morton wrote:
> > On Wed, 17 Nov 2010 21:53:52 +0100
> >
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > On Wednesday, November 17, 2010, Ondrej Zary wrote:
> > > > Hello,
> > > > the nasty memory-corrupting hibernation bug
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=15753 is back since
> > > > 2.6.35.5. 2.6.35.4 works fine, 2.6.35.5 crashes after two days.
> > > >
> > > > It seems to be caused by b77c254d8d66e5e9aa81239fedba9f3d568097d9.
> > >
> > > Can you, _please_, always put all of the basic commit info (subject,
> > > author, who signed it off) in bug reports?
> > >
> > > In this particular case I don't have a -stable tree handy at the moment
> > > and can't even see what the commit is.
> >
> > You can simply do a google search for the commit ID.  It is
>
> Thanks! :-)
>
> > commit b77c254d8d66e5e9aa81239fedba9f3d568097d9
> > Author: Hugh Dickins <hughd@google.com>
> > Date:   Thu Sep 9 16:38:09 2010 -0700
> >
> >     swap: prevent reuse during hibernation
>
> So I guess we should Cc Hugh ...

Oops, my bad. I was in hurry and somehow missed that he's not on the Cc list.

-- 
Ondrej Zary
