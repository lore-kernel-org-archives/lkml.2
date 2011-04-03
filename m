Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1DCJ7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:59:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57621 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1DCJ7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ey2APJ2sjdLGHq2vsW5ojvwD3c/LGi6qAZLCBws7HEm41u7E72JLEcXB8oLMuH+PtR
         yP0w9xP+RVXTOZN5ao+MOOc1Ih1Jo3SJGu+Ow9t1/2btd6DSJnFdCzwZtYhvbnMoyoLW
         wf8uRU8iePaFf2Oq74QR9jNK7vT4bMog5hcys=
MIME-Version: 1.0
In-Reply-To: <4D982E89.8070502@redhat.com>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
Date: Sun, 3 Apr 2011 12:59:05 +0300
X-Google-Sender-Auth: 6M-7WK92JWgSpXW63A7SLvlVhtI
Message-ID: <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Pekka Enberg <penberg@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Sun, Apr 3, 2011 at 11:23 AM, Avi Kivity <avi@redhat.com> wrote:
>> Note that this is a development prototype for the time being: there's no
>> networking support and no graphics support, amongst other missing
>> essentials.
>
> Mind posting a roadmap?  I would put smp support near the top.  This sort of
> thing has to be designed in, otherwise you wind up with a big lock like
> qemu.

What are the pain points with qemu at the moment?

SMP, networking, and simpler guest to host communication from shell
are most interesting missing features for me. I'd also love to have
GPU support for X and friends.

                        Pekka
