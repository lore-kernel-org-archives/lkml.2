Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2CFMwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:52:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45757 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2CFMwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:52:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.52.91.82 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120305223745.GC16312@ubuntu-macmini>
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
	<1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
	<20120305220651.GB16312@ubuntu-macmini>
	<CA+5PVA5nRvtDPXgen5=10=Yt2YdQAUo-K+OK8MXENiQ7wEQCYg@mail.gmail.com>
	<20120305223745.GC16312@ubuntu-macmini>
Date: Tue, 6 Mar 2012 07:52:39 -0500
Message-ID: <CA+5PVA6kaf3Hwyy5twtfcry6oEQA29J4o8X_1ear7N+d0GQPEw@mail.gmail.com>
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
From: Josh Boyer <jwboyer@gmail.com>
To: Josh Boyer <jwboyer@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 5:37 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Mon, Mar 05, 2012 at 05:10:50PM -0500, Josh Boyer wrote:
>> On Mon, Mar 5, 2012 at 5:06 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
>> > On Wed, Feb 22, 2012 at 08:37:37AM -0600, Seth Forshee wrote:
>> >> Apple laptops with hybrid graphics have a device named gmux that
>> >> controls the muxing of the LVDS panel between the GPUs as well as screen
>> >> brightness. This driver adds support for the gmux device. Only backlight
>> >> control is supported initially.
>> >>
>> >> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>> >
>> > Ping. Is there anything that would prevent getting this into 3.4?
>>
>> I sent a list of patches that seemed ready for 3.4 to Matthew last week.  This
>> was on the list and he seemed to agree.  I would guess he just either needs
>> a minion, a clone, or a time machine.  Or maybe all three.
>
> Huh, guess I missed that, and even now I can't seem to find it. Any
> chance you could point me to the list?

Oh, sorry.  It was a direct mail to Matthew, not on a list.  My mistake.

Basically, it consisted of this:

"OK, so digging through the platform list, here are the patches that seem
to be bugfixes that should probably go into 3.3:

http://article.gmane.org/gmane.linux.acpi.devel/51594
http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/2908
http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/2943
(replaces 3aa4634c0f23593c5be7e819e02dd6ace671820a in your
linux-next/for_linus branches)


For 3.4, these seem ready (in addition to what you have in linux-next):
http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/2968
http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/2888
http://article.gmane.org/gmane.linux.drivers.platform.x86.devel/2934
http://thread.gmane.org/gmane.linux.drivers.platform.x86.devel/2929
"

I might spend some time today creating a fixed up git tree with that set of
changes/patches and see what comes of it.

josh
