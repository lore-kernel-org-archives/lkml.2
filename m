Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1FOK2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:28:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60559 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1FOK2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mEy+/1gHDlShcM1XO7SMProSlfXTxnFJbXGLVseGq6JKFxRpdVhLdqCgI5ViGHFCpF
         Lki5sVxgePvcUO4K5J67WhXGBo1lmWgf1x9cX4gUaTk3ZSbQPIfceGnyuX8pN6hmU6ba
         AwMQXnnO+PFRwxyz3EIwkVxSlZmcSA/m+Gk7g=
Message-ID: <4DF88934.9040808@gmail.com>
Date: Wed, 15 Jun 2011 12:28:04 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: bug: kernel 3.0-rc3 not relocatable on i386?
References: <1308125533.4641.33.camel@nathan.suse.cz>	 <BANLkTikoxYAz7G7pvKABbVPzOuxUzLkO=Q@mail.gmail.com>	 <1308132078.4641.38.camel@nathan.suse.cz> <1308132448.4641.41.camel@nathan.suse.cz>
In-Reply-To: <1308132448.4641.41.camel@nathan.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-06-11 12:07, Petr Tesarik schreef:
> Ah, it turns out this is in fact reported here:
>
> http://sourceware.org/bugzilla/show_bug.cgi?id=12327
>
> But the patch was reverted by commit
> 6b35eb9ddcddde7b510726de03fae071178f1ec4, so these binutils have been
> broken again since January.
>
> Yes, I've got binutils-2.21 here. :/
Ah, my bad for the stray path though, looked the only thing slightly related to breakage recently. I guess upgrading binutils triggered it. :)

~Maarten
