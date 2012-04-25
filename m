Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab2DYJrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:47:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63352 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2DYJrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:47:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
Date: Wed, 25 Apr 2012 17:47:05 +0800
Message-ID: <CADLM8XPryGVVWVruB=sZ9zxPp-nEhz8xKeMhY3u8KBShk2suBQ@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Wei Yang <weiyang.kernel@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> busn_alloc patchset should address your concern.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-busn-alloc
>
Yinghai

You mean this patch 44b2347b fix the problem?

In the comment, "do pass0 for all good bridge".
Then there are totally two pass for a whole pci domain?

I tried "git grep busn_alloc", but not find anything.

> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Richard Yang
Help You, Help Me
