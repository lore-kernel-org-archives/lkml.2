Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab0JQTtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 15:49:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51703 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab0JQTtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 15:49:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=F9kuDXYb7uF6NIQ8GfbbV6D6Kf0YYdfHrl+2nnXjMOHON8RSMM4S2Zn07Fpw/IwmRy
         /UzOF5cjG/RcZ5hNSl64BwbJJ/wpyAVnx9yfwVL3ss0aeUhjQbCQwkaEGcNzZgiomafd
         +99OamrlWx7VpLbYorNBnIofApmiFgeqOpT6w=
MIME-Version: 1.0
In-Reply-To: <1287343839.1998.699.camel@laptop>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
 <1287303678.20968.37.camel@Joe-Laptop> <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
 <1287310889.1998.153.camel@laptop> <1287334498.20968.53.camel@Joe-Laptop> <1287343839.1998.699.camel@laptop>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 17 Oct 2010 15:49:18 -0400
X-Google-Sender-Auth: bWYorQHGKwNox9-a5V8lA-wzBeU
Message-ID: <AANLkTikaxf-Fh9qUxsXNO5=r+SoxbzYXvCjFcHQLcXjy@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: allow single space before labels
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 15:30, Peter Zijlstra wrote:
> On Sun, 2010-10-17 at 09:54 -0700, Joe Perches wrote:
>> There are a half dozen or so in sched.c
>
> Unlike some people, I've actually got something better to do than
> whitespace patches.. they'll change next time the code in question needs
> to change.

sounds like a good reason to shut up the new unintended warnings
-mike
