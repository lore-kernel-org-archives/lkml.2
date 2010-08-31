Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0HaThk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab0HaThj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:37:39 -0400
Message-ID: <4C7D5A01.5070806@redhat.com>
Date: Tue, 31 Aug 2010 15:37:37 -0400
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc14 Thunderbird/3.1
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Harald Hoyer <harald@redhat.com>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, greg@kroah.com,
        sds@tycho.nsa.gov
Subject: Re: selinux vs devtmpfs (vs udev)
References: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com> <AANLkTi=aEdKM_hunJmPzXxPqkrbok+_C6QUKf8v=Q+18@mail.gmail.com> <1283210070.3284.139.camel@dhcp231-106.rdu.redhat.com> <4C7CC107.1050304@redhat.com> <4C7D0DAD.9030505@redhat.com> <4C7D141A.9060102@redhat.com> <4C7D1868.3090701@redhat.com> <1283267765.3284.150.camel@dhcp231-106.rdu.redhat.com> <4C7D1E1B.4020700@redhat.com> <1283268367.3284.154.camel@dhcp231-106.rdu.redhat.com> <4C7D248A.2080507@redhat.com> <AANLkTikhc1Nu5PsQqzKL0PXY3juOxwuPOsu0ZKvzfCJ3@mail.gmail.com>
In-Reply-To: <AANLkTikhc1Nu5PsQqzKL0PXY3juOxwuPOsu0ZKvzfCJ3@mail.gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/31/2010 03:32 PM, Kay Sievers wrote:
> On Tue, Aug 31, 2010 at 17:49, Harald Hoyer <harald@redhat.com> wrote:
>> https://bugzilla.redhat.com/show_bug.cgi?id=575128#c14
>> https://bugzilla.redhat.com/attachment.cgi?id=442223&format=raw
>>
>> udev/udev-node.c
>>
>> +                       /* set selinux file context on add events */
>> +                       if (strcmp(udev_device_get_action(dev), "add") == 0)
>> +                               udev_selinux_lsetfilecon(udev, file, mode);
> 
> I can't access these bugs.
> 
> Does that makes sense/work for you?
>   http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=326c5fc3ea684825629eccaf33a548759162a539
> 
> Kay
If it only labels on node creation, yes that makes sense to me.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkx9WgAACgkQrlYvE4MpobPoJgCeLTV4TWUi0Mh/m0P783/PPyBa
s2MAnRK5pUSJqVT+mAHtxPyFIEe9hepf
=HDZq
-----END PGP SIGNATURE-----
