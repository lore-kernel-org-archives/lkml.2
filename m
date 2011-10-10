Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1JJQf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:35:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35865 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1JJQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:35:58 -0400
MIME-Version: 1.0
In-Reply-To: <20111010142418.GC21944@kroah.com>
References: <20111006190526.GA13883@redhat.com>
	<201110071640.53827.frank.mehnert@oracle.com>
	<CAOJsxLGE_WqV=43JRjL_Mo3X5t11iDR2BNfBmRZWW3rt1CNbTA@mail.gmail.com>
	<20111010142418.GC21944@kroah.com>
Date: Mon, 10 Oct 2011 19:35:58 +0300
X-Google-Sender-Auth: _xV9278JDJhJ1lA9zKiFlhpcegE
Message-ID: <CAOJsxLGzyDut=6B-Xc0jBWFPNdTzG8vzoVJdyLfBbjyRDx-eWw@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
Cc: Frank Mehnert <frank.mehnert@oracle.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 5:24 PM, Greg KH <greg@kroah.com> wrote:
>> > And of course, helpful and constructive critism is always appreciated.
>>
>> What is holding you back from submitting the vbox modules to kernel
>> staging tree and starting to clean it up for proper inclusion?
>
> You haven't actually read the vbox kernel code before, have you :)

I actually have and had a rough patch that added the code to staging
directory in the kernel tree.

Admittedly I don't remember anything about the code but surely it
meets the standards of what we already have there? :-)

                        Pekka
