Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1BZXDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 18:03:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33500 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab1BZXDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:03:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Do8Dbue9tiVdbd6mtSko8cUrrO4bp9bo//nAcNCakNaUDArGJoHaVAEhAD2LFJm6YV
         Pte1iuVsB6x4jMIlx1rCVFKIt3zIrfE+cT3o16RkOTds2Txx9x1VOWkHnfRUDwgJ5zoy
         Lb+ZQiYtj6NPWZTC9CpqSXLHqf9q+rWhfcZeU=
MIME-Version: 1.0
In-Reply-To: <20110226221838.GA24028@merkur.ravnborg.org>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
	<20110226221838.GA24028@merkur.ravnborg.org>
Date: Sat, 26 Feb 2011 18:03:13 -0500
Message-ID: <AANLkTi=+AU3gJJOov8R1fNcZVE7iNpbTLDuMB5PHUk8s@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Arnaud Lacombe <lacombar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 26, 2011 at 5:18 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sat, Feb 26, 2011 at 02:47:01PM -0500, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Fri, Feb 25, 2011 at 1:07 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > We already have something remotely similar in kconfig.
>> > We use the following list:
>> > config DEFCONFIG_LIST
>> >        string
>> >        depends on !UML
>> >        option defconfig_list
>> >        default "/lib/modules/$UNAME_RELEASE/.config"
>> >        default "/etc/kernel-config"
>> >        default "/boot/config-$UNAME_RELEASE"
>> >        default "$ARCH_DEFCONFIG"
>> >        default "arch/$ARCH/defconfig"
>> >
>> I may argue that anything within the Linux tree which point
>> _by_default_ to something outside the tree itself is broken.
> The above allows the average user to just type "make menuconfig"
> and then the configuration of the current kernel is presented to
> the user.
I'm sure there is a way to do this from the Kbuild and not from the Kconfig.

> This is convinient in many cases.
this is a subjective point of view. I do build a lot of kernel for
anything but the current machine I'm using.

> We know the /proc/config.gz is an incresingly popular way to gain
> access to the configuration of the running kernel. So extending
> the already know and working way to obtaing the configuration
> of the running kernel to suppport /proc/config.gz is logical.
Then again, this should be doable from Kbuild.

> The fact that the configuration is gzipped does not warrant
> a new option to deal with this that almost duplicate the
> existing functionality.
>
agree.

 - Arnaud
