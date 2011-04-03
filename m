Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1DCKcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 06:32:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61709 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1DCKcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 06:32:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=attCPJ8IFDX0CwUFr4+p+HkGm4xRdx4vs34cbmGrlRw4Xr6g9k3pfuCpOvczP57Itl
         apmj1s7youbfhtFInzz00yzmnAvU4qc6IJDEN6O4rlLzbE5goA585F9k1iUpDRLY58KB
         +dm6UDYjCPR80e1jzfw3gkI+Ekd5cEml+qAw8=
MIME-Version: 1.0
In-Reply-To: <4D984A58.5090902@redhat.com>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<BANLkTik5-ohx47AyLz_mJkCqNtO4uKVBew@mail.gmail.com>
	<4D984A58.5090902@redhat.com>
Date: Sun, 3 Apr 2011 13:32:18 +0300
X-Google-Sender-Auth: iI4HrBTW4LD7cINrS40GapGIH4E
Message-ID: <BANLkTinKJ68hbt-SZUUMJoKcm4ttnzxv8Q@mail.gmail.com>
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

On Sun, Apr 3, 2011 at 1:22 PM, Avi Kivity <avi@redhat.com> wrote:
>> It's definitely not a toy, it's my main virtualization tool of choice
>> for kernel development! ;-)
>>
>> The features you mention are crucial for servers but not for desktop.
>> I personally don't have much need for managing and live-migrating
>> Windows guests but if someone is interested in working on that, we're
>> happy to take patches!
>
> Well, I'd say you do need generic guest support for desktop (but not the
> other stuff I mentioned).  Are you planning to add a real GUI?

Yes, we'll hopefully add GUI at some point.

Generic guest support would be cool but like I said, I personally
don't need it because I'm mostly interested in running Linux guests.
Windows is totally uninteresting and I'm hoping we can get away with
virtio drivers for other FOSS kernels.

                         Pekka
