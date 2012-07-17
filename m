Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2GQTFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:05:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38903 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab2GQTFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:05:30 -0400
Message-ID: <5005B737.1030203@us.ibm.com>
Date: Tue, 17 Jul 2012 12:04:23 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.0-stable: Fix for leapsecond deadlock & hrtimer/futex
 issue
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com> <20120717175741.GA3665@1wt.eu> <5005ABC2.8050006@us.ibm.com> <5005AD06.8080403@us.ibm.com> <20120717182601.GB14609@burratino>
In-Reply-To: <20120717182601.GB14609@burratino>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071719-5806-0000-0000-0000176441CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 11:26 AM, Jonathan Nieder wrote:
> John Stultz wrote:
>
>> Are there any other test suites that folks would recommend I look
>> into for merging these (and other time related) tests?
> Would it be possible to put them in the kernel tree somewhere, for
> example under tools/testing/?
Huh.  I guess its possible.  However I'd like to avoid starting 
yet-another-testing-framework.

The idea of keeping kernel tests close to the code could be nice since 
it might avoid the bit-rot many testing suites get where bad tests start 
failing and no one cares enough or has the context to sort out fixing 
false positives.

But looking at the ltp project page, it seems there have been some good 
cleanups in fixing known failures since last I looked (4 or so years 
back).  So it might be LTP is the proper place for this.

thanks
-john


