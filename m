Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1AUVBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:01:13 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:37438 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752206Ab1AUVBL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:01:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=b2RY/xb7O6wxh8yIa9rR0S3Vd1Q5wDH+s0znvBVFLfNefeyVq88KXwb2xB05W9P7Bvw+rRTF9m5sbGr/zE9WVSeifQ4qOrdxi2Y/jl6teeHbVR1BjKHqnbgQJqsSfGdC;
Date: Fri, 21 Jan 2011 13:01:06 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Dima Zavin <dmitriyz@google.com>, Joe Perches <joe@perches.com>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110121130106.5f30908d@jbarnes-desktop>
In-Reply-To: <1295642995.19880.42.camel@m0nster>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	<AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
	<1295571359.9236.53.camel@m0nster>
	<1295574085.4096.6.camel@Joe-Laptop>
	<1295575123.9236.54.camel@m0nster>
	<1295576730.4096.24.camel@Joe-Laptop>
	<1295624801.19880.13.camel@m0nster>
	<20110121094827.41818a55@jbarnes-desktop>
	<20110121095658.1ab623fe@jbarnes-desktop>
	<1295632828.19880.22.camel@m0nster>
	<20110121100441.06a94482@jbarnes-desktop>
	<1295633882.19880.31.camel@m0nster>
	<AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	<1295642995.19880.42.camel@m0nster>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 12:49:55 -0800
Daniel Walker <dwalker@codeaurora.org> wrote:

> On Fri, 2011-01-21 at 12:44 -0800, Dima Zavin wrote:
> > Really though? Let's look at one of them:
> > 
> 
> >       2 Arve Hjønnevåg <arve@android.com>
> >       6 Brian Swetland <swetland@google.com>
> >      14 Dima Zavin <dima@android.com>
> >       2 Haley Teng <Haley_Teng@htc.com>
> >       1 Iliyan Malchev <malchev@google.com>
> >       5 Mike Chan <mike@android.com>
> 
> I'll add this list into the commit text ..

Sounds like a good example of a patch where you should preserve the
author field as well.

-- 
Jesse Barnes, Intel Open Source Technology Center
