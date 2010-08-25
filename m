Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab0HYUTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:19:04 -0400
Received: from prod-mail-xrelay04.akamai.com ([96.6.114.79]:56527 "EHLO
	prod-mail-xrelay04.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab0HYUTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:19:01 -0400
Message-ID: <4C757AB4.10708@akamai.com>
Date: Wed, 25 Aug 2010 13:19:00 -0700
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32 cgroup regression
References: <4C74274D.9060300@akamai.com> <1282715761.20033.23.camel@marge.simson.net>
In-Reply-To: <1282715761.20033.23.camel@marge.simson.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2010 10:56 PM, Mike Galbraith wrote:
> 
> Excellent timing you have.  I have a tree of backports, but I wasn't
> counting this commit as a must have, merely highly desirable.  This
> testcase showed that it's a needed fix.
>   

I'd be interested in looking at this tree when it's available.

Thanks
Josh
