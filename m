Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1CVSKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:10:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61442 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1CVSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SM1Tx7IP/fBbdLlrMDmtXvlFfQq9c6pVal1vxGZ27LfgsWe5Ki8caxZHXyXQLjNY/M
         CkAMzHDZJXnwurPR2bJsXepaVcvkG+eC3qIluo6HUxvpK11KORIFmLIyYqgK/YtJBM41
         1j4yYNIYs2az35TO03RQnMJqcEwO2mkApUEZY=
MIME-Version: 1.0
In-Reply-To: <20110322133101.GB24006@gere.osrc.amd.com>
References: <AANLkTim3gpBUtDQ=WnLRjzuwpNe=+m4wLK=maS1tLc8U@mail.gmail.com>
	<20110322133101.GB24006@gere.osrc.amd.com>
Date: Tue, 22 Mar 2011 19:10:09 +0100
Message-ID: <AANLkTimz0GR7HXgY5jxogfkNyJ2iVYWJGHRhsZtO4T+A@mail.gmail.com>
Subject: Re: Machine Check Exception and cpufreq
From: Giorgio <mywing81@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, linux@brodo.de, dougthompson@xmission.com,
        mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/22 Borislav Petkov <bp@amd64.org>:
> this is very interesting. Question: is it possible to retest with
> a newer kernel from upstream (say 2.6.38) to see whether the issue
> persists? I'd like to rule out the possibility that powernow-k8 is
> not causing any trouble which has been fixed in newer kernels in the
> meantime.
>
> Thanks.

Hello Borislav,

thanks for your quick reply. Yes, I only tested it with the stock
2.6.32 kernel shipped with Ubuntu 10.04, but I will download the
latest stable kernel from kernel.org (2.6.38) and test again. I'll
come back to you in the following days. Regards,

Giorgio Vazzana
