Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888Ab2DKA1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:27:05 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57289 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828Ab2DKA1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:27:03 -0400
MIME-Version: 1.0
In-Reply-To: <1673842.NkbWD6ec4k@sifl>
References: <1540670.AFBi1SpGoi@sifl>
	<CA+5PVA6vQF5T4j2-GoURrLshzCybELd-Hn3cgEd5nHVcQgNV7w@mail.gmail.com>
	<1524909.RpscfJeEfO@sifl>
	<1673842.NkbWD6ec4k@sifl>
Date: Tue, 10 Apr 2012 20:27:01 -0400
Message-ID: <CA+5PVA5yDpMiB-_4c=n21ztxWNyvhw2uaCRMf=z+22PP7=0Z8Q@mail.gmail.com>
Subject: Re: ANN: libseccomp
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Moore <pmoore@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, libseccomp-discuss@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 4:29 PM, Paul Moore <pmoore@redhat.com> wrote:
> On Monday, April 09, 2012 05:28:41 PM Paul Moore wrote:
>> On Monday, April 09, 2012 04:14:15 PM Josh Boyer wrote:
>> > On Mon, Apr 9, 2012 at 4:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > > On 04/09/2012 12:25 PM, Josh Boyer wrote:
>> > >> Do you think the GPLv2 license will limit adoption of it's usage across
>> > >> a wider variety of software projects?  I'm not anti-GPL by any means
>> > >> but I am slightly surprised libseccomp is using it.
>> > >>
>> > >> josh
>> > >
>> > > Yes, on the surface of it this would seem more like LGPL material.
>> > >
>> > > Other than that, very much needed!
>> >
>> > Agreed on both points.  I only brought this up now as it's very early
>> > in the project's lifetime.  If a relicense were to happen it would be
>> > better to do it before a larger number of developers started
>> > contributing to the project.
>>
>> You both bring up a good point, the LGPL seems like a better choice.  I
>> chose GPLv2 when I started simply out of habit; it is a license I am both
>> familiar and comfortable with so it has a tendency to get used when I start
>> a new chunk of code.
>>
>> As you pointed out, the project is still very new with only a handful of
>> authors beyond myself.  I'll get in touch with them privately to make sure
>> they are comfortable with the relicense and assuming there are no problems
>> I'll report back when everything has been changed.
>
> Just an update, the project has just been relicensed under the LGPLv2.1
> license.

Wonderful.  Thanks for the quick action on that.  Hopefully it will
spread the adoption of the library once the seccomp patches are in the
mainline kernel.

josh
