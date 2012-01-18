Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2ARWr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:47:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36425 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2ARWr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:47:58 -0500
MIME-Version: 1.0
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
Date: Wed, 18 Jan 2012 14:47:57 -0800
X-Google-Sender-Auth: j6YuXlC-8F3CwBZWMrUUaWnnCwY
Message-ID: <CAGXu5jJ3WMUDS0svkoviLx_OOQFdjofMt3PwHdeLiouFbDVShw@mail.gmail.com>
Subject: Re: [PATCH v5] ramoops: use pstore interface
From: Kees Cook <keescook@chromium.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 2:40 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
>>>>  static int __exit ramoops_remove(struct platform_device *pdev)
>>>>  {
>>>> +#if 0
>>>> +     /* TODO(kees): We cannot unload ramoops since pstore doesn't support
>>>> +      * unregistering yet.
>>>> +      */
>>>
>>> Well that sucks.  Is pstore getting fixed?
>>
>>Tony, any plans for changing this? I'm ready when it does! :)
>
> I have an question about this.
>
> Are there any specific usecases you need to unload ramoops?

For me, it would be useful during development. Beyond that, not that I can see.

-Kees

-- 
Kees Cook
ChromeOS Security
