Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965323Ab2JCRQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:16:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51877 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2JCRQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:16:21 -0400
Message-ID: <506C6F59.8050403@linaro.org>
Date: Wed, 03 Oct 2012 10:01:13 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [ 008/180] 2.6.32.x: ntp: Fix leap-second hrtimer livelock
References: <20121001225157.951753597@1wt.eu> <1349275814.16173.13.camel@deadeye.wl.decadent.org.uk> <20121003160151.GE3889@1wt.eu>
In-Reply-To: <20121003160151.GE3889@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100317-7606-0000-0000-0000042BC515
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 09:01 AM, Willy Tarreau wrote:
> Hi Ben,
>
> On Wed, Oct 03, 2012 at 03:50:14PM +0100, Ben Hutchings wrote:
>> On Tue, 2012-10-02 at 00:52 +0200, Willy Tarreau wrote:
>>> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
>> [...]
>>
>> No objection, but please remove the '2.6.32.x: ' prefix from the subject
>> before committing this and the other ntp/timekeeping/hrtimer fixes.
> Good point. Initially John used this as a differenciator when sending to
> stable@ but I directly applied the mbox without fixing the subject, which
> isn't a good thing.
Do let me know if there's a better way for me to send them (and keep the 
versions straight) without creating more work for you.

thanks
-john

