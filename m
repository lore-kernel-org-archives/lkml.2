Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab0J0Qim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:38:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48344 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0J0Qik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Knln6/p7p7bUfMS+9JtoLb84xrI1EdD877OJ3H9/dSc7nLjAjLA0j4q2koNMuF4V2Q
         Lx7L8mCGFTUwoJL4shXBKLHarqRRuoya3yfLczN6tK0jJus3T1tem75m5EB1LyZmwjpD
         cfsxB++jT5CHKyncKEFf6yigI3Yh3r3XBUrL8=
Message-ID: <4CC8558C.3000209@gmail.com>
Date: Wed, 27 Oct 2010 18:38:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com> <4CC84597.4000204@gmail.com> <4CC84846.6020304@redhat.com> <4CC84B14.1030303@gmail.com> <4CC8550B.4060403@redhat.com>
In-Reply-To: <4CC8550B.4060403@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 06:36 PM, Mauro Carvalho Chehab wrote:
> Basically, af9015 broke due to (3), as .small_i2c = 1 means nothing. It should be using
> .small_i2c = TDA18271_16_BYTE_CHUNK_INIT, instead.
> 
> What I don't understand is why a patch doing this change didn't fix the issue. Please
> test the patch I posted on the original -next thread. Let's try to identify why
> tda18271_write_regs() is not breaking the data into smaller writes.

It helps, but one needs to unplug and replug the device. So care to
respin the pull request with the patch included?

thanks,
-- 
js
