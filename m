Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2I0JbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:31:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:52710 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab2I0JbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:31:24 -0400
Message-ID: <50641CE5.8070107@mev.co.uk>
Date: Thu, 27 Sep 2012 10:31:17 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: staging tree closed for 3.7
References: <20120926175606.GA10762@kroah.com> <20120926175634.GB10762@kroah.com>
In-Reply-To: <20120926175634.GB10762@kroah.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-26 18:56, Greg Kroah-Hartman wrote:
> On Wed, Sep 26, 2012 at 10:56:06AM -0700, Greg Kroah-Hartman wrote:
>>
>> With 3.6 about to be released, I've now closed the 3.7 staging-next tree
>> for new features / cleanups.  It's bug-fixes only now until 3.7-rc1 is
>> out.
>
> Oh, and if I've missed any patches that people have sent me already,
> please let me know, because I don't have them anymore.

I have an outstanding patch for the jr3_pci driver that was mostly 
__iomem tagging, but also included a one-line fix for an invalid iomem 
dereference.  Do you want me to resend the whole patch or just split out 
the one-line fix for 3.6?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
