Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1BJTOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:14:17 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39241 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1BJTOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ljQamuhTU+De5l5LIJjYmo3WWNXmKuSQkxl8gQH3JmrSgmHB6AyXYIn+0GXYfSMgET
         xLNckimltcLhskgSvnjYoOoSdMfeG68dXEZPqvJYQR0JDqBp4sMQFOxQbxegnbDAw6WJ
         9WTPescphkepAMyUktrGacK7FTyaXiA3ACy9U=
MIME-Version: 1.0
In-Reply-To: <20110210184713.GA15882@suse.de>
References: <0d30dc$l1diqi@orsmga001.jf.intel.com>
	<20110210175855.GC13795@suse.de>
	<AANLkTimyxSy2FDBjh-xR1XmuZ9c7KjYHN-CjFAfp4Eu_@mail.gmail.com>
	<20110210184713.GA15882@suse.de>
Date: Thu, 10 Feb 2011 21:14:14 +0200
Message-ID: <AANLkTi=7_WH_7t1SPJW4rKxz380iA7RSLKrYWeT8HTce@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] Intel(R) MEI Driver
From: Tomas Winkler <tomasw@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Oren Weil <oren.jer.weil@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, david@woodhou.se,
        david.woodhouse@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 8:47 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Feb 10, 2011 at 08:43:57PM +0200, Tomas Winkler wrote:
>> On Thu, Feb 10, 2011 at 7:58 PM, Greg KH <gregkh@suse.de> wrote:
>> > On Thu, Feb 10, 2011 at 01:54:54AM -0800, Oren Weil wrote:
>> >> Intel(R) Management Engine Interface (Intel(R) MEI) Driver
>> >> ==========================================================
>> >>
>> >> This patch contains a new Intel driver for the Linux kernel: The Intel(R) MEI Driver.
>> >
>> > This patch?  What patch, there is no patch here.
>> >
>> > You sent out 13 emails with the same exact Subject line, which is not
>> > acceptable at all, and mighty confusing.
>> >
>> >> This set of patches is for review purposes; the driver code
>> >> for pull is in the David Woodhouse public git repository:
>> >> http://git.infradead.org/linux-2.6-mei.git
>> >
>> > No, we need these as patches, not as a pull request.  Please work on
>> > fixing up your individual patches, that's the only way this is going to
>> > be accepted.
>>
>> There was a suggestion of splitting the driver into per file patches
>> to be reviewable  rather then creating gigantic driver patch.
>> I personally would prefer the later one  would happy to here any other
>> suggestions how to split driver.
>
> Per-file is ok, but just provide proper documentation, don't break the
> build, and do it the correct way, like everyone else does every day.
> This isn't something new people...

I was actually looking into Documentation/SubmittingDrivers and
SubmittingPatches and there is much suggestion how to handle that.
I'll spell it  just make sure I understand correctly, we do per file
patches with Kconfig + Makefile patch as last in the series so the
build won't break....


Thanks
Tomas
