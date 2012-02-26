Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab2BZE4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 23:56:23 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:34970 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab2BZE4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 23:56:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.229.136.82 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120224221459.GA5254@polaris.bitmath.org>
References: <20120224171752.GB9485@kroah.com>
	<20120224183423.GA23284@kroah.com>
	<20120224191535.GA4505@polaris.bitmath.org>
	<20120224192643.GB24120@kroah.com>
	<20120224201027.GA4859@polaris.bitmath.org>
	<20120224201655.GA5994@kroah.com>
	<20120224203715.GA4995@polaris.bitmath.org>
	<20120224205651.GA13333@kroah.com>
	<20120224212238.GA5178@polaris.bitmath.org>
	<20120224213027.GB15735@thunk.org>
	<20120224221459.GA5254@polaris.bitmath.org>
Date: Sat, 25 Feb 2012 23:56:21 -0500
Message-ID: <CAArOQ2WCXDf2ymxihFdjKhBFMVhtoupVRB97_LsEky4HAGq0hA@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Bobby Powers <bobbypowers@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "Ted Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jidong Xiao <jidong.xiao@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 5:14 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Fri, Feb 24, 2012 at 04:30:27PM -0500, Ted Ts'o wrote:
>> On Fri, Feb 24, 2012 at 10:22:38PM +0100, Henrik Rydberg wrote:
>> >
>> > Maintenance. Sure, as soon as an area grows too large for a single
>> > person, the current structure will ensure it divides so that the patch
>> > stream becomes manageable. We have already seen ample examples of
>> > that. But the overall structure of the kernel will become less and
>> > less manageable, and the likelihood of duplicates and maintenance
>> > problems will increase.
>>
>> Not necessarily.  The primary area of growth has been hardware support
>> (i.e., drivers), and that scales quite well.
>>
>> The main issue is the grown of intra-system interfaces, and you
>> haven't shown that this has happened in anything approaching the
>> levels where we need to worry.  If we add a new file system, like
>> btrfs, that doesn't add a whole new set of VFS interfaces, and it's
>> not like we need to worry about communication interfaces between btrfs
>> and ext4....
>
> True, and the emergent interface (vfs) is even accessible in
> userspace, so all is good in that department for now. Conversely, you
> have not shown that this can go on forever. ;-)
>
> The main issue that set me off has been sufficiently diluted in the
> (selective) discussion so as to no longer make sense as a reply: At
> some point, in-tree or out-of-tree will no longer be distinguishable,

Please explain how you would be unable to distinguish between a driver
that lives in the kernel source tree, and one that does not.

yours,
Bobby

> and the question is if/when/why something would/should happen as a
> consequence. A matter of politics, if you will. It seemed like an
> honest question starting this thread, and I think it is fair to keep
> it in mind as such.
>
> Thanks.
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
