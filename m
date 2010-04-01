Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0DASRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:17:23 -0400
Received: from www17.your-server.de ([213.133.104.17]:49230 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab0DASRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:17:17 -0400
References: <1269775909.5301.4.camel@localhost.localdomain> <20100331163234.8e875ae8.akpm@linux-foundation.org> <1270089696.2941.217.camel@dhcp235-240.rdu.redhat.com>
Message-Id: <25D576C5-F4E5-49BF-A20C-361214155BBA@m3y3r.de>
From: Thomas Meyer <thomas@m3y3r.de>
To: Eric Paris <eparis@redhat.com>
In-Reply-To: <1270089696.2941.217.camel@dhcp235-240.rdu.redhat.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPod Mail (7E18)
Mime-Version: 1.0 (iPod Mail 7E18)
Subject: Re: 2.6.34-rc2: "ima_dec_counts: open/free imbalance"?
Date: Thu, 1 Apr 2010 20:17:40 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.04.2010 um 04:41 schrieb Eric Paris <eparis@redhat.com>:

> On Wed, 2010-03-31 at 16:32 -0700, Andrew Morton wrote:
>> On Sun, 28 Mar 2010 13:31:49 +0200
>> Thomas Meyer <thomas@m3y3r.de> wrote:
>>
>>> This warning/error/notice is new in 2.6.34-rc2+:
>>
>> Let's add some cc's.  It might be a DRM bug.
>>
>> I'll ask Rafael and Maciej to track this as a post-2.6.33 regression,
>> thanks.
>
> The IMA code hasn't changed since .33 so my guess is something new the
> drm code is doing with obj->filp.
>
> Thomas, any idea what the newest kernel was that didn't show you this
> problem?

I first saw this message in 2.6.34-rc2 (+free_init_pages patch), but  
that was also the first bootable kernel for me as I was hit by the  
NO_BOOTMEM bug...

>  It might help cut down my search in the morning....
>
> -Eric
>
