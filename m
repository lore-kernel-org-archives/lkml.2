Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab0JQU0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 16:26:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34356 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab0JQU0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 16:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=XQAQiDz+FsKU7lBLf+MfeVEMnH2Z5VUbP1L4NIrkgn9y9/nHEepe0J1RsApocfH9pk
         CkCX1vYwL1MncdqgFGPZ0IAg1KyEEa14c3+OZSAUp6f0QfrqlOFgxHWatUAofSnLAYd7
         +3pQxrg0kFBwr2bBnNzphvCO1HHplHXwBiIuI=
MIME-Version: 1.0
In-Reply-To: <1287345710.1998.735.camel@laptop>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
 <1287303678.20968.37.camel@Joe-Laptop> <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
 <1287310889.1998.153.camel@laptop> <1287334498.20968.53.camel@Joe-Laptop>
 <1287343839.1998.699.camel@laptop> <AANLkTikaxf-Fh9qUxsXNO5=r+SoxbzYXvCjFcHQLcXjy@mail.gmail.com>
 <1287345710.1998.735.camel@laptop>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 17 Oct 2010 16:26:25 -0400
X-Google-Sender-Auth: 5gDMa8TZDWgUvx5Fhyp9eAgVViU
Message-ID: <AANLkTimixEGQTYrM7ShodtKeC97e0uPNRhWQn8F+-Nui@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: allow single space before labels
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 16:01, Peter Zijlstra wrote:
> On Sun, 2010-10-17 at 15:49 -0400, Mike Frysinger wrote:
>> sounds like a good reason to shut up the new unintended warnings
>
> I'm failing to see any logic there, old code doesn't generate warnings,
> its new code that would, and new code should never have any whitespace
> in front of labels.

it's a waste of time to massage code to one person's opinion
-mike
