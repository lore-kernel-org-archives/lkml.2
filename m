Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab2LaJDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 04:03:42 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60758 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2LaJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 04:03:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAK4r=d6--9FniNQ10Ja0z4hUQHuTnCPjsHJUHDmFP7Eeo8NwAA@mail.gmail.com>
References: <CAK4r=d6--9FniNQ10Ja0z4hUQHuTnCPjsHJUHDmFP7Eeo8NwAA@mail.gmail.com>
From: Vivek Satpute <vivekonline86@gmail.com>
Date: Mon, 31 Dec 2012 14:33:20 +0530
Message-ID: <CAK4r=d6TjnbR2dU2AHia18WEGpK1w06mC5tCMH6VSF5vrsuyhw@mail.gmail.com>
Subject: Re: Request-queue not getting process even after calling unplug
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kindly let me know if I am posting query in wrong Forum. If yes, then
could anyone point me to the appropriate forum ?


Thanks in advance,
Vivek Satpute

On Sun, Dec 30, 2012 at 5:02 PM, Vivek Satpute <vivekonline86@gmail.com> wrote:
> Hi All,
>
> I am working on RHEL5.8 (kernel-2.6.18-308) and facing weird behavior
> with the IO subsystem.
>
> My testcase requires to form the SCSI request manually and send it
> down to the underlying HBA
> for further IO processing. To achieve this I have formed the SCSI
> request, packed it inside the
> new request. Later on I am queuing the request to device's
> request-queue using function - elv_add_request( ).
> Request is getting queued correctly in a queue. Further I called
> unplug on a queue, still it is not getting
> processed further by IO scheduler. Request remains stuck in queue itself !
>
> Strange part is, same code is working successfully on other kernel versions,
> but I am facing the issue only on kernel-2.6.18-308.
>
> Can anyone help me to understand why request is being stuck in a queue
> ? How can I debug this further ?
>
>
> Thanks in advance!
> Vivek Satpute
