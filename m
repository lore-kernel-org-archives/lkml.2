Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0IVHps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 03:45:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33407 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0IVHpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 03:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=JVp3BLqFe/VZ1vvws1ri8z06G1AwAIrUob0DbzWLBk/6BjXeoGVak0vVFb1S4PUHKa
         KR9OXRdK+MIt8NAH5ORTK1IH6cDLcWHLIoEcUo6fj7LWOlUu1kfI7eOKIXwNRRPT52TO
         P0yJ6NXuKosZg3U97AyTI05e6I47w7AemQ6oY=
MIME-Version: 1.0
In-Reply-To: <1284675049-23479-6-git-send-email-virtuoso@slind.org>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org> <1284675049-23479-6-git-send-email-virtuoso@slind.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 22 Sep 2010 03:45:22 -0400
X-Google-Sender-Auth: NbIVV2kbumLMoLD7Sn7E5dzZnJs
Message-ID: <AANLkTinPQxUPsNyK8nGvLVEQgpy4S1Y=-GQi=w3UuWYn@mail.gmail.com>
Subject: Re: [PATCH 5/7] wire up sys_time_change_notify() on blackfin
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Robin Getz <robin.getz@analog.com>, Philippe Gerum <rpm@xenomai.org>,
        "David S. Miller" <davem@davemloft.net>, Yi Li <yi.li@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 18:10, Alexander Shishkin wrote:
> +#define __NR_time_change_notify        374

we're in the process of allocating NR 374 for cacheflush (for
userspace trampoline handling with gcc), so this will need to be
changed
-mike
