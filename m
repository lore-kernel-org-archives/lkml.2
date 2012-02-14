Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2BNP4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:56:03 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:45358 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab2BNPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:55:58 -0500
Message-ID: <4F3A836E.1020208@polito.it>
Date: Tue, 14 Feb 2012 16:53:18 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Daniel J Walsh <dwalsh@redhat.com>
CC: Harald Hoyer <harald@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        initramfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        systemd-devel@lists.freedesktop.org, selinux@lists.fedoraproject.org
Subject: Re: dracut: ordering of modules
References: <1328886121.2472.19.camel@falcor> <4F38DEF0.8010202@redhat.com> <4F38E337.7030200@polito.it> <4F38E5F4.9070009@redhat.com> <4F3941A2.3040205@redhat.com>
In-Reply-To: <4F3941A2.3040205@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan

i confirm this issue happens in a Fedora 16 system with the
selinux-policy package installed.

The selinux dracut module tries to load the policy but returns
with the error below. After switching root, the policy is
successfully loaded by Systemd.

Thanks

Roberto Sassu


On 02/13/2012 06:00 PM, Daniel J Walsh wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 02/13/2012 05:29 AM, Harald Hoyer wrote:
>> Am 13.02.2012 11:17, schrieb Roberto Sassu:
>>> Hi Harald
>>>
>>> this functionality seems to be broken in dracut due to a change
>>> in the SELinux load_policy tool. After enabling the selinux
>>> module in dracut, i obtain:
>>>
>>> [    3.369059] dracut: Loading SELinux policy [    3.449850]
>>> dracut: /sbin/load_policy: Can't load policy: No such file or
>>> directory [    3.659899] dracut: Switching root
>>>
>>
>> This error can have multiple causes... Dan?
>
> Well likeliest would be selinux-policy package is not installed.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.12 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>
> iEYEARECAAYFAk85QaIACgkQrlYvE4MpobMNbwCgi8JG0fmlQsnvo2HNnA+Orxzr
> UYcAoKqHj0+Ll8lfbYpvGzANxck4MAwP
> =geIr
> -----END PGP SIGNATURE-----

