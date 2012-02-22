Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2BVVCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:02:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52506 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab2BVVCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:02:38 -0500
Message-ID: <4F4557E1.3020304@zytor.com>
Date: Wed, 22 Feb 2012 13:02:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2012 12:54 PM, Linus Torvalds wrote:
>
> I *really* hope that the people who could reproduce this bug will test the
> back-port series too, since I never actually saw the bug personally to
> begin with. And again, big thanks to Raphael who helped pinpoint and debug
> this.
>

I will run my tests on it overnight.

	-hpa

