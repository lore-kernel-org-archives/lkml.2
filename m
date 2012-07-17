Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab2GQTSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:18:40 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46402 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2GQTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:18:36 -0400
Message-ID: <5005BA6A.5050407@us.ibm.com>
Date: Tue, 17 Jul 2012 12:18:02 -0700
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
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com> <20120717175741.GA3665@1wt.eu> <5005ABC2.8050006@us.ibm.com> <5005AD06.8080403@us.ibm.com> <20120717182601.GB14609@burratino> <5005B737.1030203@us.ibm.com> <20120717191418.GF14609@burratino>
In-Reply-To: <20120717191418.GF14609@burratino>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071719-6148-0000-0000-000007BEACD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 12:14 PM, Jonathan Nieder wrote:
> John Stultz wrote:
>> On 07/17/2012 11:26 AM, Jonathan Nieder wrote:
>>> Would it be possible to put them in the kernel tree somewhere, for
>>> example under tools/testing/?
>> Huh.  I guess its possible.  However I'd like to avoid starting
>> yet-another-testing-framework.
> Too late: http://thread.gmane.org/gmane.linux.kernel/1223571/focus=1226221
:)

Although Andrew's comment: "All these features are Linux-specific. 
Standard interface features (eg POSIX) are and should be tested via 
other externally-maintained test suites."  suggests my time tests should 
go elsewhere.

thanks
-john

