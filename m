Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab0KQVEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 16:04:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757797Ab0KQVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 16:04:43 -0500
Date: Wed, 17 Nov 2010 13:04:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ondrej Zary <linux@rainbow-software.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
Message-Id: <20101117130422.d9de48d8.akpm@linux-foundation.org>
In-Reply-To: <201011172153.52644.rjw@sisk.pl>
References: <201011171139.33398.linux@rainbow-software.org>
	<201011172153.52644.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 21:53:52 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, November 17, 2010, Ondrej Zary wrote:
> > Hello,
> > the nasty memory-corrupting hibernation bug 
> > https://bugzilla.kernel.org/show_bug.cgi?id=15753 is back since 2.6.35.5.
> > 2.6.35.4 works fine, 2.6.35.5 crashes after two days.
> > 
> > It seems to be caused by b77c254d8d66e5e9aa81239fedba9f3d568097d9.
> 
> Can you, _please_, always put all of the basic commit info (subject, author,
> who signed it off) in bug reports?
> 
> In this particular case I don't have a -stable tree handy at the moment and
> can't even see what the commit is.

You can simply do a google search for the commit ID.  It is


commit b77c254d8d66e5e9aa81239fedba9f3d568097d9
Author: Hugh Dickins <hughd@google.com>
Date:   Thu Sep 9 16:38:09 2010 -0700

    swap: prevent reuse during hibernation
 
