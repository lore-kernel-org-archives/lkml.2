Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1DLLLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:11:54 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40700 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1DLLLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oeKLGwZ2urY6Q/peeTJy8T2dsRli5Ao/drJvlcaQw2R3D47Os45RPNZQCm7XeefI30
         yBkBgDdgO102cH3otJEGVFPChEgnHQz/mpsdkfCcXLvUKx8mUD7Pj/iP05YsH7cxJEKy
         Op3eT47bOaXKiwIB184de3tzOdFxIbHeBWq/Y=
MIME-Version: 1.0
In-Reply-To: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
	<20110411233358.dd400e59.akpm@linux-foundation.org>
	<20110412161315.B518.A69D9226@jp.fujitsu.com>
	<BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
Date: Tue, 12 Apr 2011 14:11:52 +0300
Message-ID: <BANLkTikjcws6c9hK7WdyrDT_+ss6EfLr0g@mail.gmail.com>
Subject: Re: mm: convert vma->vm_flags to 64bit
From: Alexey Dobriyan <adobriyan@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 2:06 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Tue, Apr 12, 2011 at 10:12 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> After next year? All developers don't have to ignore compiler warnings!
>
> At least add vm_flags_t which is sparse-checked, just like we do with gfp_t.

Or even vma_flags_t.
