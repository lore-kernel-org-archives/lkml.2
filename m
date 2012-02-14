Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab2BNSx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:53:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab2BNSx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:53:27 -0500
Message-ID: <4F3AADA1.5090508@redhat.com>
Date: Tue, 14 Feb 2012 13:53:21 -0500
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: initramfs@vger.kernel.org, systemd-devel@lists.freedesktop.org,
        selinux@lists.fedoraproject.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Harald Hoyer <harald@redhat.com>
Subject: Re: dracut: ordering of modules
References: <1328886121.2472.19.camel@falcor> <4F38DEF0.8010202@redhat.com> <4F38E337.7030200@polito.it> <4F38E5F4.9070009@redhat.com> <4F3941A2.3040205@redhat.com> <4F3A836E.1020208@polito.it>
In-Reply-To: <4F3A836E.1020208@polito.it>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/14/2012 10:53 AM, Roberto Sassu wrote:
> Hi Dan
> 
> i confirm this issue happens in a Fedora 16 system with the 
> selinux-policy package installed.
> 
> The selinux dracut module tries to load the policy but returns with
> the error below. After switching root, the policy is successfully
> loaded by Systemd.
> 
> Thanks
> 
> Roberto Sassu
> 
> 
Well in F16 dracut is not supposed to load the policy.
> On 02/13/2012 06:00 PM, Daniel J Walsh wrote: On 02/13/2012 05:29
> AM, Harald Hoyer wrote:
>>>> Am 13.02.2012 11:17, schrieb Roberto Sassu:
>>>>> Hi Harald
>>>>> 
>>>>> this functionality seems to be broken in dracut due to a
>>>>> change in the SELinux load_policy tool. After enabling the
>>>>> selinux module in dracut, i obtain:
>>>>> 
>>>>> [    3.369059] dracut: Loading SELinux policy [
>>>>> 3.449850] dracut: /sbin/load_policy: Can't load policy: No
>>>>> such file or directory [    3.659899] dracut: Switching
>>>>> root
>>>>> 
>>>> 
>>>> This error can have multiple causes... Dan?
> 
> Well likeliest would be selinux-policy package is not installed.
> 
> -- selinux mailing list selinux@lists.fedoraproject.org 
> https://admin.fedoraproject.org/mailman/listinfo/selinux

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk86rZ4ACgkQrlYvE4MpobPKXwCfbVdkQuaylTtHIASztazyokqN
u4wAnR9bueXLrFH4vvDxSPYSNqBDYP19
=W0oJ
-----END PGP SIGNATURE-----
