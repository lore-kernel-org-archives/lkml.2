Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab2BBSED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:04:03 -0500
Received: from mail-we0-f194.google.com ([74.125.82.194]:59809 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2BBSEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAPNxggbTGeDE34kKPEza4iedJ+ZLOgw+mn9mir6N=fx9DpXcfg@mail.gmail.com>
References: <CAPNxggbTGeDE34kKPEza4iedJ+ZLOgw+mn9mir6N=fx9DpXcfg@mail.gmail.com>
Date: Thu, 2 Feb 2012 19:03:59 +0100
Message-ID: <CAPNxggam6=vesPJ9Bedf6fTSEw1nJDGH7ExC-g=SAiaRf9ecWw@mail.gmail.com>
Subject: Re: An alternative for tasklist_lock in a module?
From: "Arokux B." <arokux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph and Andrew,

you are correspondingly the author and signer of the mentioned commit.
Could I get some feedback from you?

Thanks.





On Tue, Jan 31, 2012 at 7:58 PM, Arokux B. <arokux@gmail.com> wrote:
> Hi,
>
> (for learning purposes) I would like to iterate through all the tasks
> in a module and output different information about them. For this task
> I need to lock the list of all tasks (need I?). I've seen some example
> in the kernel code which lock tasklist_lock. However this symbol
> cannot be used by modules. Its export was removed by
> c59923a15c12d2b3597af913bf234a0ef264a38b commit.
>
> Is there any other way I can lock the list of tasks then? Or I'm supposed
> not to use this list at all?
>
> Thanks
