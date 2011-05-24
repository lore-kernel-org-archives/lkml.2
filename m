Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab1EXSsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:48:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62371 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab1EXSsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WHTYJkpNCrx7KXoMAA44cKLLqgybU2LaAKy4WKtEtvrJpNGfH/NvCqsvsVRu0H7at2
         Cp2e5Aj1y1pDQ5ekk0gc7QqaxAqSMZihbptJ5Ri+yi2L0n6u1TDf7MMuGEU9sl1WUqRa
         8PUrosoncJKKeTdN5c0Wn4oeshGXmOlo6SeI4=
MIME-Version: 1.0
In-Reply-To: <BANLkTimGGukCD_eLfCTXWjbiz=7ucEwj7Q@mail.gmail.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
	<20110523231721.GM10009@thunk.org>
	<4DDAEC68.30803@zytor.com>
	<BANLkTikGfVSAMY2a2yiXaNpvBVvF8YdMEA@mail.gmail.com>
	<alpine.LNX.2.01.1105241409280.15351@frira.zrqbmnf.qr>
	<BANLkTimCXVdVa6KLRG8GJR1gJY=7_5SkOA@mail.gmail.com>
	<alpine.LNX.2.01.1105241500410.23085@frira.zrqbmnf.qr>
	<BANLkTinNK+9XijCN0YGXyvLQ8_npPTG2cQ@mail.gmail.com>
	<20110524154348.27ba649d@lxorguk.ukuu.org.uk>
	<BANLkTi=Xuk4=Q43QV1pv33K=J2FFZBLLtQ@mail.gmail.com>
	<4DDBEC91.8020004@zytor.com>
	<BANLkTimGGukCD_eLfCTXWjbiz=7ucEwj7Q@mail.gmail.com>
Date: Tue, 24 May 2011 14:48:08 -0400
Message-ID: <BANLkTi=Rky8zGrJ7TSF0MumzQWjpsD7Lcw@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
From: eschvoca <eschvoca@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jacek Luczak <difrost.kernel@gmail.com>,
        Jan Engelhardt <jengelh@medozas.de>, linux-arch@vger.kernel.org,
        linux-mm <linux-mm@kvack.medozas.de>, "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 1:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 24, 2011 at 10:36 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> I think this whole discussion misses the essence of the new development
>> model, which is that we no longer do these kinds of feature-based major
>> milestones.
>
> Indeed.
>
> It's not about features. It hasn't been about features for forever.
>
> So a renumbering would be purely about dropping the numbers to
> something smaller and more easily recognized. The ABI wouldn't change.
> The API wouldn't change. There wouldn't be any big "because we finally
> did xyz".
>

Me, a nobody end user, would prefer a version number that corresponded
to the date.  Something like:

%y.%m.<stable patch>
%Y.%m.<stable patch>

Then users would know the significance of the number and when a vendor
says they support Linux 11.09 the user will immediately know if they
are up to date.

Using the date also clearly communicates it is not about features.
When there is a 3.0 (4.0) release people expect big new features and
API/ABI breakage.

My 2 cents.
