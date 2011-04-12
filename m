Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1DLLHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:07:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34198 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1DLLHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ATtztx02kZYyuCnVb4UH7Y5Zp7UVuIfh8iWdDB8PE9Sz2HfwzTk5t1ERiekRmIGJ7V
         p5uvPzt5aumd2roWYTHGOc/Z4Mpp9/QN3kCZZ5+blNpMS46uEmcDCapM1P4HlurJFSwO
         lmMmPED4/e8HEE6OTueXESecr3DH8nhi00EFI=
MIME-Version: 1.0
In-Reply-To: <20110412161315.B518.A69D9226@jp.fujitsu.com>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
	<20110411233358.dd400e59.akpm@linux-foundation.org>
	<20110412161315.B518.A69D9226@jp.fujitsu.com>
Date: Tue, 12 Apr 2011 14:06:51 +0300
Message-ID: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
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

On Tue, Apr 12, 2011 at 10:12 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> After next year? All developers don't have to ignore compiler warnings!

At least add vm_flags_t which is sparse-checked, just like we do with gfp_t.

VM_SAO is ppc64 only, so it could be moved into high part,
freeing 1 bit?
