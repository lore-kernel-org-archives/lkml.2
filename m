Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2BMSOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:14:46 -0500
Received: from nm23.access.bullet.mail.mud.yahoo.com ([66.94.237.88]:24801
	"HELO nm23.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755569Ab2BMSOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:14:44 -0500
X-Yahoo-Newman-Id: 655939.55554.bm@smtp103.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: nBoVz7kVM1m1o3Kocx0gWOrKVhyq56yJn0FwFBK3alxlZe4
 coAd.UxI58.jWyUXe34j71mTcVa8aIRIcEzWi1fxbtHOXZ3zhuCBLfZusbgH
 g54rNsrdrdiqBIDOXBG73kKv2EZIif7XlfcAleU5daQAPjvjYvihur1GE7f8
 8ZyxhEZzleIVjAPWNOmAkVieqS4TS9l3c.gn9z55D46IzvBVfqh3_o06uqmz
 gV.w_8LvWe59OzwenKQL0JsFlXUi9wnS8jJ4KmTLmDYa51WXOD3jcdZ6Li_p
 x37V.k8Y929u.M6K9tvu7kPYD0hHc_3SXrPwKXGERtRoB2xauqQWduaIxawS
 54qwFmODOxh4BJiVEd1LkkRO9x49sgmY3ROM_JkeIzCLfq59Y4B1mk_JOAmQ
 aqKPpzPZK0eZqUEjKOGCwUr_snfaUUe0sitM0TYBNPjqaEZ4zn1fWwTc-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F395313.5030704@schaufler-ca.com>
Date: Mon, 13 Feb 2012 10:14:43 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
CC: bharat dhaker <bharat4u.u@gmail.com>, linux-kernel@vger.kernel.org,
        kernelnewbies@kernelnewbies.org,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: difference between ACLs and SElinux
References: <CANWArFvKbGcP_VFedyM1SGQsXKPx5Md9Ak0vxqfoCcGq9Ozruw@mail.gmail.com> <1329124259.25984.304.camel@thorin>
In-Reply-To: <1329124259.25984.304.camel@thorin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/2012 1:10 AM, Bernd Petrovitsch wrote:
> Hi!
>
> On Mon, 2012-02-13 at 14:30 +0530, bharat dhaker wrote:
> [...]
>> I want to know the differences between ACLs and SElinux.

The differences are many:

ACLs are an extension of the standard Linux Discretionary
Access Control (DAC) mechanism. SELinux is a supplemental
Mandatory Access Control (MAC) scheme.

ACLs are based on the withdrawn POSIX P1003.1e/2c DRAFT
Standard and reflects a rough consensus of the industries
Unix security experts of its day. SELinux started out as
the Flask micro-kernel security architecture.

ACLs are part of the base kernel, while SELinux is a
Linux Security Module.


>> Does anyone know
>> which file-systems supports SElinux?

It's really much more the other way around. SELinux
uses extended attributes (xattrs) and can take advantage
of any filesystem that supports them.

> Google knows;-)
>
> Actually you make a small partition for each filesystem and try it out.
>
> 	Bernd

