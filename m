Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1HCMVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:21:31 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39565 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1HCMVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1108022151490.28467@chino.kir.corp.google.com>
References: <20110514102014.12739.91576.reportbug@eiffel4.mcfm>
	<20110801122537.GA9469@mwanda>
	<alpine.DEB.2.00.1108011206130.28986@chino.kir.corp.google.com>
	<20110802225825.GE3839@shale.localdomain>
	<alpine.DEB.2.00.1108022151490.28467@chino.kir.corp.google.com>
Date: Wed, 3 Aug 2011 14:21:24 +0200
Message-ID: <CAKWSe6BUZqs+YBxPqhO0hsa_Xhju7yHiAj4s3QdH+fh5+65Cxg@mail.gmail.com>
Subject: Re: openssh-server: sshd (<pid>): /proc/<pid>/oom_adj is deprecated,
 please use /proc/<pid>/oom_score_adj instead.
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 3, 2011 at 6:53 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 3 Aug 2011, Dan Carpenter wrote:
>
>> Could we do it in a way that made it more clear that the problem was
>> an old version of openssh-server and not the kernel?  The information
>> is there, but it's overwhelmed in stack trace spam.  Also the kernel
>> is tainted now because of sshd.  Maybe the message could include a
>> link to a wiki page that told people which version off sshd uses the
>> new proc file.
>>
>
> Would you like to ack http://marc.info/?l=linux-kernel&m=131227886118365?

As a side note, Fedora 15 has new openssh packages with the backport of the
 5.7p1 fix to use /proc/<pid>/oom_score_adj.

Kudos to the Fedora dev team for the quick turnaround on my bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=727335

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
