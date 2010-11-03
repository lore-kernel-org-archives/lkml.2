Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0KCQej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:34:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40836 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0KCQeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:34:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l7pdqRdP4nLFgpYNO0gji78uC3cCx3NzAGf6vg5demPJtaOwokFKGxPrH7Ij8UXNmy
         yMiNAjifh1N6h2H7RUDzXYPbkF4puxW2Xi5VBh0b0zXas7l9wxCxKYzSNn9LwM/Pp2Zs
         8u7fLhXyQr76DtA+l/hFMurPr4aZUBwmcGLYw=
Date: Thu, 4 Nov 2010 00:37:20 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: jovi zhang <bookjovi@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Jesper Juhl <jj@chaosbits.net>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
Message-ID: <20101103163702.GA4683@hack>
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net> <AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com> <20101031173336.GA28141@balbir.in.ibm.com> <alpine.LNX.2.00.1011010639410.31190@swampdragon.chaosbits.net> <alpine.DEB.2.00.1011030937580.10599@router.home> <AANLkTinhAQ7mNQWtjWCOWEHHwgUf+BynMM7jnVBMG32-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinhAQ7mNQWtjWCOWEHHwgUf+BynMM7jnVBMG32-@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 11:20:32PM +0800, jovi zhang wrote:
>On Wed, Nov 3, 2010 at 10:38 PM, Christoph Lameter <cl@linux.com> wrote:
>> On Mon, 1 Nov 2010, Jesper Juhl wrote:
>>
>>> On Sun, 31 Oct 2010, Balbir Singh wrote:
>>
>>> > > There are so many placed need vzalloc.
>>> > > Thanks, Jesper.
>>
>>
>> Could we avoid this painful exercise with a "semantic patch"?
>>
>Can we make a grep script to walk all files to find vzalloc usage like this?
>No need to send patch mail one by one like this.

No, grep doesn't understand C. :)

-- 
Live like a child, think like the god.
 
