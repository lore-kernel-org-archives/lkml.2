Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1FMK2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:28:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:32918 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1FMK2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:28:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Cehe/gYPlBEwf5nyFaz20F1T6N0RDIFzRhB8/vCD0T2TNmH4BSz9/zjF81rKtNe9zH
         JTGfnU0KSnwhtilyKmgRb/bG9djVrs5XczXOJQPOZ0ABjM8NuY19gA4nQQW/S+IBvqoK
         5umng7hXlqE76PLxbhCgDTerpbXsCTooPlhmw=
MIME-Version: 1.0
In-Reply-To: <4DAF6C0B.3070009@gmx.de>
References: <4DAF6C0B.3070009@gmx.de>
Date: Mon, 13 Jun 2011 12:28:37 +0200
Message-ID: <BANLkTi=puXde+bq9PD9foGT35oNU+Vag1A@mail.gmail.com>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
From: Antonio Messina <arcimboldo@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 1:28 AM, Thomas Sattler <tsattler@gmx.de> wrote:
> Hi there ...
>
> While running firefox (>50 open Tabs), khugepaged jumped to 99.99%
> (according to 'iotop').  I killed firefox and nearly all running
> programs but khugepaged was still at 99.99% IO while the system
> was almost idle. I waited about 10 minutes, no improvement, so
> I rebooted the machine.

Dear all,

I have a similar issue, but I am running a 2.6.38-6 kernel on a HPC
cluster, and I had this issue quite often lately, especially on jobs
accessing the network (but since we are using NFS and MPI, many jobs
are actually accessing the network).

I'm using an SMP, non-PREEMPT kernel (2cpu*8 cores each machine). I
can provide you more information if you need, but please reply to me
since I'm not subscribed to the mailing list.

.a.
