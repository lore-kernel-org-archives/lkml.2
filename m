Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0LCCo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 21:44:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42393 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab0LCCoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 21:44:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BiEq+HehvnuvY/a33ZnlcMesMK4Y0mdN4oFi1FvA8A3gp7tiUiNFGxphhnaq1BI5gi
         /56o1J3RdA9cFY9CgzROOKTm8O+QvGDbYVCif/nBf+q5HhOd92Gl3h8s8Iz21NpXSp6U
         fGten5BQ3Dv/yTESbvHrEkj/qSTAB3fqdI3uM=
Message-ID: <4CF859AA.8010505@lwfinger.net>
Date: Thu, 02 Dec 2010 20:44:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Bug #22562] Regression in 2.6.37-rc1 - logs spammed with "unable
 to enumerate USB port" - bisected to commit 3df7169e
References: <1OMp3vU_qjP.A.JXG.uxC-MB@chimera> <gUkHV_Vc3aE.A.qi.gzC-MB@chimera>
In-Reply-To: <gUkHV_Vc3aE.A.qi.gzC-MB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 05:41 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22562
> Subject		: Regression in 2.6.37-rc1 - logs spammed with "unable to enumerate USB port" - bisected to commit 3df7169e
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2010-11-02 22:32 (31 days old)
> First-Bad-Commit: http://git.kernel.org/linus/3df7169e73fc1d71a39cffeacc969f6840cdf52b
> Message-ID	: <4CD09166.4060202@lwfinger.net>
> References	: http://marc.info/?l=linux-kernel&m=128873713207906&w=2

Still present in 2.6.37-rc4. The box with the problem has been repaired and I
can now debug the problem again. Any hints would be appreciated.

Larry
