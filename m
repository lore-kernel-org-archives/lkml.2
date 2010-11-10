Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0KJSHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:07:16 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55155 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0KJSHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:07:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dUnoF2QWk3jlwVYfsKaa2PuxPxhsO16Ii7CQ9oTn5WrPcuxd7iwCoTdgLT4qElVb5R
         olB9E5fDkIm8XLWyaIaYONqEh3hQxccc56lxoc56Mfh2NRS5V1Byq7MBfkEQGHdPDa8Y
         POyJu7PjpQdEvNIpQMSfML9fyTZ6xOmHBNqzg=
MIME-Version: 1.0
In-Reply-To: <4CD95B32.9020105@redhat.com>
References: <1289069578-1907-1-git-send-email-tdent48227@gmail.com>
	<4CD95B32.9020105@redhat.com>
Date: Wed, 10 Nov 2010 13:07:13 -0500
Message-ID: <AANLkTi=5fcT5fdZHhcLnB9iatyqf_09ZgJJgXdUZ8emc@mail.gmail.com>
Subject: Re: [PATCH] KVM x86: Makefile clean up
From: Tracey Dent <tdent48227@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/9/10, Avi Kivity <avi@redhat.com> wrote:
> On 11/06/2010 08:52 PM, Tracey Dent wrote:
>> Changed makefile to use the ccflags-y option instead of EXTRA_CFLAGS.
>
> Applied, thanks.
>
> --
> error compiling committee.c: too many arguments to function
>
>

thanks
