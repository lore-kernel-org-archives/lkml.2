Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1LRSaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 13:30:00 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:44374 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1LRS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 13:29:59 -0500
Message-ID: <4EEE3124.7070605@gmail.com>
Date: Sun, 18 Dec 2011 13:29:56 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        "Doug Ledford (commit_signer:5/9=56%)" <dledford@redhat.com>,
        "\"Eric W. Biederman\" (commit_signer:2/9=22%)" 
	<ebiederm@xmission.com>,
        "Joe Korty (commit_signer:2/9=22%)" <joe.korty@ccur.com>,
        "David Howells (commit_signer:2/9=22%)" <dhowells@redhat.com>
Subject: Re: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
References: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/9/11 5:35 PM), kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> 
> Mqueue limitation is slightly naieve parameter likes other ipcs
> because unprivileged user can consume kernel memory by using ipcs.
> 
> Thus, too aggressive raise bring us security issue. Example,
> current setting allow evil unprivileged user use 256GB (= 256
> * 1024 * 1024*1024) and it's enough large to system will belome
> unresponsive. Don't do that.
> 
> Instead, every admin should adjust the knobs for their own systems.
> 
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Doug Ledford<dledford@redhat.com>
> Acked-by: Joe Korty<joe.korty@ccur.com>
> Cc: Amerigo Wang<amwang@redhat.com>
> Cc: Serge E. Hallyn<serue@us.ibm.com>
> Cc: Jiri Slaby<jslaby@suse.cz>

Andrew, can you please pick up this series into your tree? because your
tree have related Doug mqueue patch series.

Thanks.


