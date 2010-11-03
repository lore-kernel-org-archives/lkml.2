Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0KCPUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:20:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62400 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab0KCPUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:20:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CNrjiidV3tse/qRvcHZhGtcmxPE3iVxJ8W6gsW0ZYttMcTUDzxxcsQKvUit21cNZbe
         SpMhtefiNaMAXJJDe9AIT/XVTvev7R2v8FnGRmnrns61gh5N31F9fDLtI9X6mdfEyaFe
         zH1C3ISeSrdhDwTyA1y6bhKfH+F5/mDj9e/wY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1011030937580.10599@router.home>
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net>
	<AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com>
	<20101031173336.GA28141@balbir.in.ibm.com>
	<alpine.LNX.2.00.1011010639410.31190@swampdragon.chaosbits.net>
	<alpine.DEB.2.00.1011030937580.10599@router.home>
Date: Wed, 3 Nov 2010 23:20:32 +0800
Message-ID: <AANLkTinhAQ7mNQWtjWCOWEHHwgUf+BynMM7jnVBMG32-@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
From: jovi zhang <bookjovi@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 10:38 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 1 Nov 2010, Jesper Juhl wrote:
>
>> On Sun, 31 Oct 2010, Balbir Singh wrote:
>
>> > > There are so many placed need vzalloc.
>> > > Thanks, Jesper.
>
>
> Could we avoid this painful exercise with a "semantic patch"?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
Can we make a grep script to walk all files to find vzalloc usage like this?
No need to send patch mail one by one like this.
