Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab2JTBX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:23:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55365 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759529Ab2JTBX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <20121019184908.GA19834@phenom.dumpdata.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
	<CAOvdn6WBj_-=3Z=ZrD670Zup4H=pvjXknvHGgjs55k3LWJyDxQ@mail.gmail.com>
	<20121017174317.GA25443@phenom.dumpdata.com>
	<CAOvdn6Uubr8J0a5+nhDKrtMYebKkBTX6+-0v0J1BGMnU-ZkVRA@mail.gmail.com>
	<20121019184908.GA19834@phenom.dumpdata.com>
Date: Fri, 19 Oct 2012 21:23:55 -0400
X-Google-Sender-Auth: 5OC3HEgsoZ9QHNUNUzWLzum3NVQ
Message-ID: <CAOvdn6V+R2+Ur-_KXWffawrLNDph7+R8UHTfwrdJo-1gUGj6xQ@mail.gmail.com>
Subject: Re: [RFC] ACPI S3 and Xen (suprisingly small\!).
From: Ben Guthro <ben@guthro.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ack.
I'm happy to test a 2nd round, if you CC me on any fixed patches (just
in case I'm not monitoring lkml / xen-devel on that particular day)

On Fri, Oct 19, 2012 at 2:49 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Wed, Oct 17, 2012 at 02:00:29PM -0400, Ben Guthro wrote:
>> I'm not sure it matters, but I'm testing against a changeset about a week old:
>> http://xenbits.xen.org/gitweb/?p=xen.git;a=commit;h=1c4a5b37b55c56e49135e65728137f54288d1fe6
>
> I was able to reproduce it with Xen 4.2 so found the culprit.
>
> .. And then another issue :-(
>
>>
>> Plus patches specific to XenClient Enterprise.
>>
>>
>> On Wed, Oct 17, 2012 at 1:43 PM, Konrad Rzeszutek Wilk
>> <konrad.wilk@oracle.com> wrote:
>> > On Wed, Oct 17, 2012 at 01:46:09PM -0400, Ben Guthro wrote:
>> >> On Wed, Oct 17, 2012 at 9:49 AM, Konrad Rzeszutek Wilk
>> >> <konrad.wilk@oracle.com> wrote:
>> >> [...]
>> >>
>> >> > The end result is this is a nice set of patches where there is only
>> >> > _one_ change in the x86 code (and it is just more of dealing with
>> >> > error case) - and the rest are all done in Xen side.
>> >>
>> >> I'm sorry to report that this series doesn't seem to work in my setup
>> >> against xen-unstable.
>> >>
>> >> To verify that it was, in fact this patch series, and not another Xen
>> >> regression - I swapped out the kernel with this patch series, with an
>> >> identical one, replacing only this series with your acpi-s3.v9 branch
>> >> - and everything worked fine.
>> >
>> > Thanks for testing it!
>> >
>> > I had tested it with Xen 4.1.3, which could be doing something different.
>> > Will see what is up.
