Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2DSSPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:15:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38474 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DSSPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:15:10 -0400
Message-ID: <4F905576.6040406@linaro.org>
Date: Thu, 19 Apr 2012 11:12:06 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D8FA1.1010107@redhat.com> <4F8F4C31.7010209@linaro.org> <4F8F555F.7040404@redhat.com> <4F8F59E2.4080301@linaro.org> <alpine.LFD.2.02.1204191437560.2542@ionos> <alpine.LFD.2.02.1204191451350.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1204191451350.2542@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041918-3270-0000-0000-000005AE7769
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 05:52 AM, Thomas Gleixner wrote:
> On Thu, 19 Apr 2012, Thomas Gleixner wrote:
>
>> We should think about the reasons why we have interrupts disabled for
>> so much time. Is that really, really necessary ?
> I'm not against making the clocksource code more robust, but I don't
> want to add crap there just to cope with complete madness elsewhere.
>

Very much agreed.
-john

