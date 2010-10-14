Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0JNQAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:00:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59887 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab0JNQAB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Cp+R2tXqmGVYFiZnKG/8toHfhJI5vu7RF+FQOtZOuUcsiEDx+HvaRX7tZZkn9Y6oQN
         YgCMjt9eRJ5AZ6/0eAAFeCStkEClJ4qzHiiW95vLbdcjjU4UAZJShWAHqNG167lqFOs5
         PUiDajVEgI3qlYfNY0RfAxvoMWted4eWWPhXI=
MIME-Version: 1.0
In-Reply-To: <4CB7240E.9000905@zytor.com>
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com>
	<4CB64D8F.9080800@zytor.com>
	<alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com>
	<4CB65262.3070507@zytor.com>
	<alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com>
	<cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com>
	<alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com>
	<4CB688F4.9040706@zytor.com>
	<alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com>
	<4CB7240E.9000905@zytor.com>
Date: Thu, 14 Oct 2010 19:00:00 +0300
X-Google-Sender-Auth: nVDeVE5ncd1Nd-TkgVW9amDMCmc
Message-ID: <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com>
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
From: Pekka Enberg <penberg@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 09:46 PM, David Rientjes wrote:
>> I'm not running a CONFIG_EMBEDDED kernel and I'm pretty sure Casey isn't
>> either, so we'd still need to carry our own patches to change the Kconfig
>> bool line anyway.
>>
>> I'm suprised that we can't allow users who definitively know that they
>> have no hardware limitations the ability to disable ZONE_DMA.  Would a
>> strong caution in the Kconfig "help" text suffice or will you not be
>> convinced?

On Thu, Oct 14, 2010 at 6:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> CONFIG_EMBEDDED *is* "I am a user who (think I) know what I'm doing".
> That is *what it is* and *all it is*.

Yup. The naming is quite unfortunate, though. Can we change it to
something else?
