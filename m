Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031172Ab2CVVxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:53:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56489 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2CVVxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:53:43 -0400
Message-ID: <4F6B9F64.5030905@canonical.com>
Date: Thu, 22 Mar 2012 17:53:40 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression introduced in v3.2.12 stable
References: <4F6B7A37.3020300@canonical.com> <20120322212644.GA30888@kroah.com> <4F6B9D0E.2040308@canonical.com> <20120322215223.GA18689@kroah.com>
In-Reply-To: <20120322215223.GA18689@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/22/2012 05:52 PM, Greg KH wrote:
> On Thu, Mar 22, 2012 at 05:43:42PM -0400, Joseph Salisbury wrote:
>> On 03/22/2012 05:26 PM, Greg KH wrote:
>>> On Thu, Mar 22, 2012 at 03:15:03PM -0400, Joseph Salisbury
>>> wrote:
>>>> I figured I'd send a heads up regarding a possible regression
>>>> in v3.2.12 stable.  The issue prevents systems from booting.
>>>> 
>>>> There have been a few bugs[0] reported against the Ubuntu
>>>> kernel, which was recently rebased to 3.2.12.  We're in the
>>>> process of bisecting now and will post an update..
>>> 
>>> What specifically happens here when the system does not boot?
>>> Any error message?  Are you sure this isn't the known pci
>>> express issue showing up here?
>>> 
>>> Can you run 'git bisect' to trace it down to a specific patch
>>> please?
>>> 
>>> thanks,
>>> 
>>> greg k-h
>> 
>> Hi Greg,
>> 
>> Thanks for the response.
>> 
>> We did some bisecting/testing and identified the bad commit in
>> 3.2.12 as the following:
>> 
>> f043ddb60c84ea64a23b755004572afe922e653c PCI: ignore pre-1.1
>> ASPM quirking when ASPM is disabled
> 
> Yup, that's the known problem one.  But, note that it does solve
> other people's problems at the moment, so you can't just ignore it
> :)
> 
> greg k-h

Thanks for the info, Greg.  I'll keep up to date on the other thread.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPa59kAAoJEGzvPSfKWxQeb5sP/RA075hhvENhxPXH6/abvdZx
/yZSybKjF+iIZIdxcauK9iVTUvhPnHwd1q5knC1tDb+kBbjqVcCbacWNVQr/kHdz
/tnhLyOFof5dVNAW+/6/C4mGtixti8+SmUW3nX0qvjaFKxYfDebFekMJ0sAfLMRd
DSEss9jA657Cct17KSDJMQfvZ6QRqMkGVtxV20fKeMeBYNRw4pyAAMUus75IGA8L
XzSA5z4Bf82MkhWc4VMY2X6awSwKyxWnyRCIllo3EdUQJQ80GYK0NVhzFyTy7Yqs
7WRkUqY99VSy0EgpRayDZ5/MRKVjbYJge8O0L3IMRVV/JbVChIQ1T1JRwnSJuGUe
dB2ZGR1uVFEJED9loB+PZNH477E11wt1UDkEsiDl9PnIghSrG2YC6YRm/K3HZrRS
7pSYqqX2xZbm+pH2rE4X0gdxnRk6RxjaQzy7bApOv9YZgVSpDKYbal6ajpLlYG4w
PAgW6NBDba6sIcBf+6mnQwzk/np7gl6MUBo+bJ2dY1nUzAFfYyp8a8359jDc1aDf
MAPpyiztiI4YnsG5WE7suPv1HAeQf8rXFaTJFIkEIRDJuT0uLnz/DKE0MJTjpiUC
SQKAMcN5H+dfgcA33QUP/SRcgTogHjG0K1SVUmo2e8pasAlBRJkSPbrZ5QVa7dkJ
z2JLI0pN27TLBTbNgWaj
=cX2M
-----END PGP SIGNATURE-----
