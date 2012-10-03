Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab2JCPXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:23:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46411 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932577Ab2JCPXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:23:10 -0400
Message-ID: <1349277786.2404.24.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [Bug 48241] New: oops when setting up LVM
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 03 Oct 2012 16:23:06 +0100
In-Reply-To: <bug-48241-11613@https.bugzilla.kernel.org/>
References: <bug-48241-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 15:04 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=48241
> 
>            Summary: oops when setting up LVM
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 3.6.0-next-20121003
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: daniel.santos@pobox.com
>         Regression: No
> 
> 
> Created an attachment (id=81921)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=81921)
> image of oops

The image says the RIP is at kthread_data + 0xb

That implies something went wrong within the workqueue or kthread
systems, I've cc'd linux-kernel, but it's a bit of a vague thing to go
on and could conceivably be a hardware issue (or some weird thread
interaction in linux-next).

The first question would be "does it happen in vanilla 3.6"?

James


