Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2DZIsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:48:55 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1105 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab2DZIsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:48:53 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4F990BE8.60805@broadcom.com>
Date: Thu, 26 Apr 2012 10:48:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "Greg KH" <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Francesco Saverio Schiavarelli" <fschiava@libero.it>,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
        "Brett Rudley" <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 23/62] brcm80211: smac: resume transmit fifo upon
 receiving frames
References: <20120424223305.GA7748@kroah.com>
 <20120424223243.950806348@linuxfoundation.org>
 <20120425223959.GA6243@burratino>
In-Reply-To: <20120425223959.GA6243@burratino>
X-WSS-ID: 6387D47E3JG900080-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 12:39 AM, Jonathan Nieder wrote:
> Greg KH wrote:
>
>> 3.3-stable review patch.
> [...]
>> commit badc4f07622f0f7093a201638f45e85765f1b5e4 upstream.
>>
>> There have been reports about not being able to use access-points
>> on channel 12 and 13 or having connectivity issues when these channels
>> were part of the selected regulatory domain. Upon switching to these
>> channels the brcmsmac driver suspends the transmit dma fifos. This
>> patch resumes them upon handing over the first received beacon to
>> mac80211.
>>
>> This patch is to be applied to the stable tree for kernel versions
>> 3.2 and 3.3.
>
> Here's a blind backport to 3.0.y for the next cycle.  Nothing scary
> involved, though of course it's completely untested.  Sensible?
>
> Thanks,
> Jonathan

We decided to only submit the patch for the mainline version of the 
driver, but your changes on the staging driver look fine. So if this 
patch is accepted in stable it is

Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS

