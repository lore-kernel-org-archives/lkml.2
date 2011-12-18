Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1LRSf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 13:35:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1LRSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 13:35:58 -0500
Date: Sun, 18 Dec 2011 10:38:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        "Doug Ledford (commit_signer:5/9=56%)" <dledford@redhat.com>,
        "\"Eric W. Biederman\" (commit_signer:2/9=22%)" 
	<ebiederm@xmission.com>,
        "Joe Korty (commit_signer:2/9=22%)" <joe.korty@ccur.com>,
        "David Howells (commit_signer:2/9=22%)" <dhowells@redhat.com>
Subject: Re: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
Message-Id: <20111218103836.258eedb8.akpm@linux-foundation.org>
In-Reply-To: <4EEE3124.7070605@gmail.com>
References: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
	<4EEE3124.7070605@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Dec 2011 13:29:56 -0500 KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> (12/9/11 5:35 PM), kosaki.motohiro@gmail.com wrote:
> > From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> > 
> > Mqueue limitation is slightly naieve parameter likes other ipcs
> > because unprivileged user can consume kernel memory by using ipcs.
> > 
> > Thus, too aggressive raise bring us security issue. Example,
> > current setting allow evil unprivileged user use 256GB (= 256
> > * 1024 * 1024*1024) and it's enough large to system will belome
> > unresponsive. Don't do that.
> > 
> > Instead, every admin should adjust the knobs for their own systems.
> > 
> > Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> > Acked-by: Doug Ledford<dledford@redhat.com>
> > Acked-by: Joe Korty<joe.korty@ccur.com>
> > Cc: Amerigo Wang<amwang@redhat.com>
> > Cc: Serge E. Hallyn<serue@us.ibm.com>
> > Cc: Jiri Slaby<jslaby@suse.cz>
> 
> Andrew, can you please pick up this series into your tree? because your
> tree have related Doug mqueue patch series.

Soon.  I need to go back and read the email trail regarding Doug's patches.
