Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1DHGT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:19:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38900 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1DHGT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BpCT47kx+NZRfTLrSiEJ2pmIwf+Z2A8QTdJhe8Py5iXM0KGeqnHDrI0YE/jT7yVFUp
         NylF36g9txOJOl2yNdAwLkZ8JPjueTzbotUkBec29E+GcYBLRBa8AlFj6cOFLeVqb2kc
         mhV2O5AyxFkBHMdE38pLQftidFdP645VnWBLs=
MIME-Version: 1.0
In-Reply-To: <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
References: <1301592656.586.15.camel@jaguar>
	<4D982E89.8070502@redhat.com>
	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>
	<4D9847BC.9060906@redhat.com>
	<4D98716D.9040307@codemonkey.ws>
	<4D9873CD.3080207@redhat.com>
	<20110406093333.GB6465@elte.hu>
	<4D9E6F6E.9050709@codemonkey.ws>
	<BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com>
Date: Fri, 8 Apr 2011 10:19:56 +0400
Message-ID: <BANLkTikBeV7m5qH3h9e-x4v6hjKVp9=0uQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 8, 2011 at 9:14 AM, Pekka Enberg <penberg@kernel.org> wrote:
> Hi Anthony,
>
> On Fri, Apr 8, 2011 at 5:14 AM, Anthony Liguori <anthony@codemonkey.ws> wrote:
>> If someone was going to seriously go about doing something like this, a
>> better approach would be to start with QEMU and remove anything non-x86 and
>> all of the UI/command line/management bits and start there.
>>
>> There's nothing more I'd like to see than a viable alternative to QEMU but
>> ignoring any of the architectural mistakes in QEMU and repeating them in a
>> new project isn't going to get there.
>
> Hey, feel free to help out! ;-)
>

Yeah, helping would be great!
