Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2DBIg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:36:56 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48746 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187Ab2DBIgz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:36:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120402082539.GA10228@dhcp-172-17-9-228.mtv.corp.google.com>
References: <CAFLxGvy+9eHbjsAm-FaV8ihXexGGLURbyDTd6X_pqE_mtOutcw@mail.gmail.com>
	<20120402082539.GA10228@dhcp-172-17-9-228.mtv.corp.google.com>
Date: Mon, 2 Apr 2012 10:36:53 +0200
Message-ID: <CAFLxGvyjVnMX6jLvGWtyup1EddFn73MUq_FkFsYBBuUNpKXrYg@mail.gmail.com>
Subject: Re: [Ocfs2-users] BUG at fs/ocfs2/extent_map.c:476
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>,
        ocfs2-users@oss.oracle.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 10:25 AM, Joel Becker <jlbec@evilplan.org> wrote:
> On Sat, Mar 24, 2012 at 09:50:49AM +0100, richard -rw- weinberger wrote:
>> Hi!
>>
>> Today one of my kvm hosts ran into this BUG.
>> The host is member of y small ocfs2-cluster (3 hosts).
>> CentOS 6.2, Kernel 3.1.1 (vanilla).
> ...
>> Is this a known/fixed bug?
>
> Not that I know of.  Have you seen it more than once?
>

No. All three cluster members had an uptime of 70 days.
Only one showed the BUG.
I've rebooted it and it seems to work fine now.

I'm not an ocfs2 expert, what could cause this kind of BUG?
Internal logic error? Filesystem corruption?

-- 
Thanks,
//richard
