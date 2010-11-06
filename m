Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0KFFva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 01:51:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52006 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab0KFFv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 01:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=awpywhAI4G7Q6Fd4IwwirgPr7f0uihb8pz7uGk07a6w1cFAShZS35sAjniematI/SD
         IzwPDoS5Ie/3dpR89pNdeVmEKTy8a6ek37qXOjOAPkdmqhkXzamJb9fBa953mt3VPB1C
         VSXHa2Qks4CLcb5AJHE5876b+CsdQmrXYZ41o=
MIME-Version: 1.0
In-Reply-To: <20101106050721.GA2194@kroah.com>
References: <AANLkTinOeby9P847gJFn_t0h5nDY7cfi3cW9hEaUrS1v@mail.gmail.com>
	<20101106050721.GA2194@kroah.com>
Date: Fri, 5 Nov 2010 22:51:26 -0700
Message-ID: <AANLkTinQK_9qp-8jJ5j3-ChUjwhGiGzAmCu5cBtHX75g@mail.gmail.com>
Subject: Re: [RFC] rbd sysfs interface
From: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 10:07 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 05, 2010 at 04:09:31PM -0700, Yehuda Sadeh Weinraub wrote:
>>
>> Does this seem sane? Any comments would be greatly appreciated.
>
> It sounds like you need to use configfs instead of sysfs, as your model
> was the reason it was created.
>
> Have you tried that?

Oh, will look at it now. With ceph (although for a different purpose)
we went through proc -> sysfs -> debugfs, however, it seems that we've
missed at least one userspace-kernel channel.

Thanks,
Yehuda
