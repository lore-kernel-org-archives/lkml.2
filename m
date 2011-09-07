Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1IGV7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:59:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48903 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab1IGV7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <4E67AF6A.9090400@redhat.com>
References: <1315406503-7883-1-git-send-email-pbonzini@redhat.com>
	<1315406503-7883-3-git-send-email-pbonzini@redhat.com>
	<CAECXXi4YW++_302mcSTX=cPjbguSqcw3Weec85VrLFv1qNHXug@mail.gmail.com>
	<4E67AF6A.9090400@redhat.com>
Date: Wed, 7 Sep 2011 17:54:01 -0400
Message-ID: <CAECXXi6NO1gvmREr_31ve-k67fsirqerdm7=ZX0tYqx+Yj52Sw@mail.gmail.com>
Subject: Re: [PATCH 2/3] nbd: add support for feature negotiation
From: Paul Clements <paul.clements@us.sios.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nbd-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 1:52 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 09/07/2011 06:30 PM, Paul Clements wrote:
>>
>> Could you name this as NBD_SET_FLAGS, as that's more consistent with
>> what it's really doing?
>
> I named it differently intentionally, actually, because it should not use
> the flags field from the network protocol as is.  Also, "features" sounds
> more like something that is optional, while unrecognized "flags" should
> probably cause a failure.

Alright, I can buy that argument -- I don't feel that strongly about it...

This looks good to me, then.

--
Paul
