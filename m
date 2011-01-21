Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1AUVCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:02:45 -0500
Received: from mail.perches.com ([173.55.12.10]:3248 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1AUVCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:02:44 -0500
Subject: Re: [PATCH 0/7] Nexus One Support
From: Joe Perches <joe@perches.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Dima Zavin <dmitriyz@google.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, davidb@codeaurora.org
In-Reply-To: <1295642995.19880.42.camel@m0nster>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
	 <1295571359.9236.53.camel@m0nster> <1295574085.4096.6.camel@Joe-Laptop>
	 <1295575123.9236.54.camel@m0nster> <1295576730.4096.24.camel@Joe-Laptop>
	 <1295624801.19880.13.camel@m0nster>
	 <20110121094827.41818a55@jbarnes-desktop>
	 <20110121095658.1ab623fe@jbarnes-desktop>
	 <1295632828.19880.22.camel@m0nster>
	 <20110121100441.06a94482@jbarnes-desktop>
	 <1295633882.19880.31.camel@m0nster>
	 <AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	 <1295642995.19880.42.camel@m0nster>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Jan 2011 13:02:42 -0800
Message-ID: <1295643762.25868.31.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 12:49 -0800, Daniel Walker wrote:
> On Fri, 2011-01-21 at 12:44 -0800, Dima Zavin wrote:
> > Really though? Let's look at one of them:
> >       2 Arve Hjønnevåg <arve@android.com>
> >       6 Brian Swetland <swetland@google.com>
> >      14 Dima Zavin <dima@android.com>
> >       2 Haley Teng <Haley_Teng@htc.com>
> >       1 Iliyan Malchev <malchev@google.com>
> >       5 Mike Chan <mike@android.com>
> I'll add this list into the commit text ..

I think it'd be better if you pull them into a
git repository, then use either:
	git format-patch
	git send-email
or
	git request-pull

That way no author history is lost.

cheers, Joe

