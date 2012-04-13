Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2DMXHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 19:07:21 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:40291 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab2DMXHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 19:07:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-160.messagelabs.com!1334358435!3786196!8
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Fri, 13 Apr 2012 18:06:31 -0500
Subject: RE: [PATCH] Documentation: remove 'linux' from dontdiff file
Thread-Topic: [PATCH] Documentation: remove 'linux' from dontdiff file
Thread-Index: Ac0ZybtN69BeUnUtRTaQJSKZYqPEqAAAA0gw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206986C0C6D@AUSP01VMBX24.collaborationhost.net>
References: <201204131552.03079.hartleys@visionengravers.com>
 <CAFLxGvwFiGghttyPmSv0L_m7GEr0FdnN6pM9Zxzr9d_vt8ercA@mail.gmail.com>
In-Reply-To: <CAFLxGvwFiGghttyPmSv0L_m7GEr0FdnN6pM9Zxzr9d_vt8ercA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 13, 2012 4:04 PM, richard -rw- Weinberger wrote:
> On Sat, Apr 14, 2012 at 12:52 AM, H Hartley Sweeten wrote:
>> The linux entry in the dontdiff file causes the include/linux
>> directory to be skipped.
>>
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> CC: Randy Dunlap <rdunlap@xenotime.net>
>
> NAK.
>
> UserModeLinux generates the linux file.

Hmm.. So we are suppressing an entire branch of the directory tree (a
fairly major one at that) for one file?

Oh well...

Regards,
Hartley
