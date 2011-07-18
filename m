Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1GRMPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:15:05 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:33892 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1GRMPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:15:03 -0400
Message-ID: <4E2423C4.6090906@msgid.tls.msk.ru>
Date: Mon, 18 Jul 2011 16:15:00 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] init: Support mounting devices from kernel command line
References: <1310979967-13470-1-git-send-email-levinsasha928@gmail.com> <CAOJsxLG9h_L8x6-W67bMT1ObQKc=ZoLUKO8ocY4QQs=0rhw5ZQ@mail.gmail.com>
In-Reply-To: <CAOJsxLG9h_L8x6-W67bMT1ObQKc=ZoLUKO8ocY4QQs=0rhw5ZQ@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

18.07.2011 15:55, Pekka Enberg wrote:
> On Mon, Jul 18, 2011 at 12:06 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> This patch adds support to mounting devices using a kernel parameter.
>>
>> Such feature is usefull for virtual guests. It allows easily automating
>> mounts without having to change the base image (which can be read-only).
>>
>> In /tools/kvm we are interested in such feature to allow us to automatically
>> mount user home directory using virtio-9p from the host to the guest
>> filesystem under '/hostfs'.

Can't the same be done within initramfs just as easy?

Long time ago when initramfs first appeared the plan was to,
more or less, move all that mounting and root= handling
functionality to userspae, and here we're adding more
to kernel.  To me that sounds backwards...

Thanks,

/mjt
