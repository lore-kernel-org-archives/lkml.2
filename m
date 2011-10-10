Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1JJQwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:52:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60333 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1JJQwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9tye+m_MV32x-Qmoj+2ie5Q0MjVzsKtuOsfgNQvK3zn9TQ@mail.gmail.com>
References: <20111006190526.GA13883@redhat.com>
	<201110071640.53827.frank.mehnert@oracle.com>
	<CAOJsxLGE_WqV=43JRjL_Mo3X5t11iDR2BNfBmRZWW3rt1CNbTA@mail.gmail.com>
	<20111010142418.GC21944@kroah.com>
	<CAOJsxLGzyDut=6B-Xc0jBWFPNdTzG8vzoVJdyLfBbjyRDx-eWw@mail.gmail.com>
	<CAPM=9tye+m_MV32x-Qmoj+2ie5Q0MjVzsKtuOsfgNQvK3zn9TQ@mail.gmail.com>
Date: Mon, 10 Oct 2011 19:51:45 +0300
X-Google-Sender-Auth: TvgKeXwyNEP4JgdtzIEMd3yllfo
Message-ID: <CAOJsxLFJDuLjM_QMjT=BR8cE2QH+jg51hP75QXWLnCHcYG-YdA@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <greg@kroah.com>, Frank Mehnert <frank.mehnert@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Mon, Oct 10, 2011 at 7:49 PM, Dave Airlie <airlied@gmail.com> wrote:
>> I actually have and had a rough patch that added the code to staging
>> directory in the kernel tree.
>>
>> Admittedly I don't remember anything about the code but surely it
>> meets the standards of what we already have there? :-)
>
> unless upstream commits to some sort of stable ABI policy there is no
> point, you'd just have to ship a module that somehow magically exposes
> different probably incompatible interfaces depending on what userspace
> was running on it.

Absolutely. No disagreement here.

                        Pekka
