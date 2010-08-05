Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab0HELlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:41:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64378 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175Ab0HELlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TpdtGvpAf6tsHnodyD8D3lMFgFyfH7AIp+FzV6ijQzk4ib3wxUo/Aqx5TpgF+tZsQ2
         AF2YCANwbXVk6OiIm4F2uxc9F9L4pX363ombPOLfpXJFVIwhBAxm+knGHEEr5ztF55sz
         L/6Vx55t8p6AST140iru8jI6SmV0e8m08i4/8=
MIME-Version: 1.0
In-Reply-To: <20100804083652.92b5b2df.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282320.39528.linux@rainbow-software.org>
	<201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTim5STgpNEdh3JSU_BG5X8Wxh-gbXDmWYLdufNb3@mail.gmail.com>
	<20100804083652.92b5b2df.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 5 Aug 2010 13:41:40 +0200
Message-ID: <AANLkTi=CjEffVkzu9P5cpM+BRM-aBNp0QgZ_Y=ssFAgt@mail.gmail.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
From: Andrea Gelmini <andrea.gelmini@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>, nigel@tuxonice.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/4 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Good, thank you for reporting !
> I'd like to add your Tested-by:

No prob.

Thanks a lot for your work,
Andrea
