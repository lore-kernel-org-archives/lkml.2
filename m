Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2ALWob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:44:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44234 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab2ALWoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:44:30 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1201121242560.17287@chino.kir.corp.google.com>
References: <CAAJw_ZvxGc8kKjLO49ONLG=AuU6-DXExwNk2PuRszF1Y0jVeog@mail.gmail.com>
	<alpine.DEB.2.00.1201121242560.17287@chino.kir.corp.google.com>
Date: Fri, 13 Jan 2012 06:44:29 +0800
Message-ID: <CAAJw_Zt9Q=Wzz2426_DaCOfvjSmGQAyPVUS1GChRCSw+w6LaUw@mail.gmail.com>
Subject: Re: how to get of the the "plus" in 3.2.0+
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 4:46 AM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 13 Jan 2012, Jeff Chua wrote:
>
>> Every time I do a fresh compile of the kernel, it append the version
>> with a "+". How can I get rid of the annoying "+" without doing
>> another major recompile or before I even start the compiling?
>>
>
> The `+´ is emitted to indicate that you have modifications to your tree
> beyond an official release, so your tree is actually not 3.2.0 but rather
> it has additional changes on top of 3.2.0.
>
> To suppress it, use "make LOCALVERSION="
>
> The version string is written to include/generated/utsrelease.h at the
> beginning of the build.

Cool! That works!

Thanks,
Jeff
