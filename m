Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2EHHZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:25:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36581 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab2EHHZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:25:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120508003822.GH4713@dhcp-172-17-9-228.mtv.corp.google.com>
References: <CAFLxGvy+9eHbjsAm-FaV8ihXexGGLURbyDTd6X_pqE_mtOutcw@mail.gmail.com>
	<20120402082539.GA10228@dhcp-172-17-9-228.mtv.corp.google.com>
	<CAFLxGvyjVnMX6jLvGWtyup1EddFn73MUq_FkFsYBBuUNpKXrYg@mail.gmail.com>
	<20120508003822.GH4713@dhcp-172-17-9-228.mtv.corp.google.com>
Date: Tue, 8 May 2012 09:25:31 +0200
Message-ID: <CAFLxGvxua-URsuOejCRGt6prr8L0NEwo4AZG14Zj-fRgTfACUA@mail.gmail.com>
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

On Tue, May 8, 2012 at 2:38 AM, Joel Becker <jlbec@evilplan.org> wrote:
> On Mon, Apr 02, 2012 at 10:36:53AM +0200, richard -rw- weinberger wrote:
>> On Mon, Apr 2, 2012 at 10:25 AM, Joel Becker <jlbec@evilplan.org> wrote:
>> > On Sat, Mar 24, 2012 at 09:50:49AM +0100, richard -rw- weinberger wrote:
>> >> Hi!
>> >>
>> >> Today one of my kvm hosts ran into this BUG.
>> >> The host is member of y small ocfs2-cluster (3 hosts).
>> >> CentOS 6.2, Kernel 3.1.1 (vanilla).
>> > ...
>> >> Is this a known/fixed bug?
>> >
>> > Not that I know of.  Have you seen it more than once?
>> >
>>
>> No. All three cluster members had an uptime of 70 days.
>> Only one showed the BUG.
>> I've rebooted it and it seems to work fine now.
>>
>> I'm not an ocfs2 expert, what could cause this kind of BUG?
>> Internal logic error? Filesystem corruption?
>
>        No idea.  That's the problem.  More details would be nice, but I
> suspect you'd rather not crash again :-)

Sorry, that's all I know.
The crash happened only once.

-- 
Thanks,
//richard
