Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1CKNCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:02:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51809 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab1CKNC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uVV2qehntWOuDAPzyBjM9/SUsvSX3a7yf05evqUcwvA0Xl3a93gqp3wOGlboKm6qLB
         zx/Ye+tPhkZTnl3obh1R6jD2bwWpWMCADKclNX4bWoEFJXOyEsGPySyGWAp1ddnPUQQx
         Nc6R75d/7p3OrMd+qZObZS2NDu+K6jyuEDhe8=
MIME-Version: 1.0
In-Reply-To: <bb0c3855a121603232d022b4062752a6@mail.gmail.com>
References: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com>
	<8yad3nlh18e.fsf@huya.qualcomm.com>
	<AANLkTin9fSw5DdqdgCEvtdtc83LFOeA7t0OAUugVmRFD@mail.gmail.com>
	<20110125102652.GB11507@n2100.arm.linux.org.uk>
	<bb0c3855a121603232d022b4062752a6@mail.gmail.com>
Date: Fri, 11 Mar 2011 18:32:26 +0530
Message-ID: <AANLkTinQf+psOnb_r38PdOzRMArcxOdKkQgO3g_3SCGS@mail.gmail.com>
Subject: Re: questions about arm trustzone
From: shiraz hashim <shiraz.linux.kernel@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        sen wang <wangchendu@gmail.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Santosh,

On Tue, Jan 25, 2011 at 5:16 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
[...]

> The code above won't give major details of how the monitor mode is
> implemented.  But as Russell said, it's pretty much vendor specific.
>
> On OMAP, We have standard API interfaces to enter into monitor
> world. One of the parameter denotes the kind of service, is
> requested.

Sorry if following are very naive.
What should be the attributes of a monitor implementation.
- Should it be un-modifiable.
- Does it run in normal (non-secure) mode ?
- Who programs the monitor (and its vector addresses) ?
- Would monitor intend to provide fixed services and how does it
decides that the request for a particular service is valid enough to
enter secure world ?
- Are monitors debuggable ?

thanks in advance for any kind help.

-- 
regards
Shiraz Hashim
