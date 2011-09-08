Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1IHHAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:00:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050Ab1IHHAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:00:47 -0400
Message-ID: <4E686815.9060901@redhat.com>
Date: Thu, 08 Sep 2011 09:00:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Paul Clements <paul.clements@us.sios.com>
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nbd-general@lists.sourceforge.net
Subject: Re: [PATCH 2/3] nbd: add support for feature negotiation
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com> <1315406503-7883-3-git-send-email-pbonzini@redhat.com> <CAECXXi4YW++_302mcSTX=cPjbguSqcw3Weec85VrLFv1qNHXug@mail.gmail.com> <4E67AF6A.9090400@redhat.com> <CAECXXi6NO1gvmREr_31ve-k67fsirqerdm7=ZX0tYqx+Yj52Sw@mail.gmail.com>
In-Reply-To: <CAECXXi6NO1gvmREr_31ve-k67fsirqerdm7=ZX0tYqx+Yj52Sw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 11:54 PM, Paul Clements wrote:
>> >  I named it differently intentionally, actually, because it should not use
>> >  the flags field from the network protocol as is.  Also, "features" sounds
>> >  more like something that is optional, while unrecognized "flags" should
>> >  probably cause a failure.
> Alright, I can buy that argument -- I don't feel that strongly about it...
>
> This looks good to me, then.

Actually no, I can do better. :)

Paolo
