Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab0LNPCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:02:13 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49916 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab0LNPCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:02:10 -0500
Date: Tue, 14 Dec 2010 20:32:13 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 10/21] Create /proc/pid/core entry
Message-ID: <20101214203213.5e809229@suzukikp>
In-Reply-To: <4D0748B4.4050109@redhat.com>
References: <20101214152259.67896960@suzukikp>
	<20101214154104.1a7bc8ae@suzukikp>
	<4D0748B4.4050109@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 18:36:36 +0800
Cong Wang <amwang@redhat.com> wrote:

> 于 2010年12月14日 18:11, Suzuki K. Poulose 写道:
> > Create the /proc/PID/core entry.
> >
> > Signed-off-by: Suzuki K. Poulose<suzuki@in.ibm.com>
> > Signed-off-by: Ananth N.Mavinakayanahalli<ananth@in.ibm.com>
> 
> Can we have a new Kconfig for this? Instead of reusing CONFIG_ELF_CORE.
> You have to make it depend on CONFIG_FREEZER, I think.
Completely agree with your suggestion. I will rework this in the next iteration.

Thanks
Suzuki
