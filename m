Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2GWPHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:07:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56340 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2GWPHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:07:44 -0400
Message-ID: <500D68B7.9060209@gmail.com>
Date: Mon, 23 Jul 2012 17:07:35 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sarbojit Ganguly <unixman.linuxboy@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
References: <CAP2rAF-ZappKmznEVjd=kQgRx__oVZ3vSE53rWDHVJf6VwMVTA@mail.gmail.com> <Pine.LNX.4.44L0.1207231044380.1633-100000@iolanthe.rowland.org> <CAP2rAF_K8Zg=+ahi23U34nb+Hewh+Xaa64jfQxBxOegN3=AnyA@mail.gmail.com>
In-Reply-To: <CAP2rAF_K8Zg=+ahi23U34nb+Hewh+Xaa64jfQxBxOegN3=AnyA@mail.gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2012 17:04, Sarbojit Ganguly wrote:
> On 23 July 2012 20:17, Alan Stern <stern@rowland.harvard.edu> wrote:

> Yes the issue is in evict() api which gets called when USB disconnect
> is triggered.
>>
>> Alan Stern
>>
> 
> Even I was confused in the beginning but after thorough check I
> confirmed its presence. I reverted back to my distro's stock kernel
> (3.2.0-26-generic) where the issue does not recur.
> 
> I could not analysed further (due to my limited knowledge of USB).

If you could bisect the problem, that would help a lot.


Daniel
