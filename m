Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363Ab0HFNqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 09:46:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35287 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0HFNqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 09:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gvVWdy4ugFduUte5DcITItJXvrou5+7eT9oKuxS8SMHIphZk6glrOGgsVBVN0BLceq
         8o8oApUSm4rmGiz9ZjQzBH/ieHRCtdhu0cztkmts5oJ/B/klyaZ4E18DLXWdn8NYSa5Q
         46QhNMMF6strO1p7eLuHN1I+pbUhc3L+MZ5Y0=
Subject: Re: [PATCH] percpu: remove address_space attribute if !SMP
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <4C5C1011.6080209@kernel.org>
References: <1281098768-5724-1-git-send-email-namhyung@gmail.com>
	 <4C5C04D8.1080103@kernel.org> <1281099197.1655.11.camel@leonhard>
	 <4C5C06A6.7070206@kernel.org> <1281101014.1655.20.camel@leonhard>
	 <4C5C1011.6080209@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 22:46:11 +0900
Message-ID: <1281102371.1655.24.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-06 (금), 15:37 +0200, Tejun Heo:
> Hello,
> 

Hi,

> On 08/06/2010 03:23 PM, Namhyung Kim wrote:
> > Sure. :-)
> > Although I'm not sure that it is really needed, if so I'll do that.
> 
> Well, the whole __percpu markup thing is to detect misuse of percpu
> pointers.  I think it would definitely be better to have the sanity
> check for UP code too.  It's not like it's gonna cost any runtime
> overhead and all the needed pieces are already there.
> 
> Thanks.
> 

I see. Thanks for the comments.

-- 
Regards,
Namhyung Kim


