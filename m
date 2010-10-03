Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0JCChf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 22:37:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34728 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0JCChe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 22:37:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XSzxcyY31kM5/mWPgjgCweuf5kBredqrugZfg7gGoTIXvy1yXouh0Alqv4kFrPJTkF
         fe4TYsZVpgQjqGLo0NQk1MVP3aCEUaiC6Cs5toU75I4o+MXlmcIFYwbNxp3kE3hkS5au
         AIHORJiJSKrrgVTNRcX+F9CFBDz2jYyBPC/3w=
MIME-Version: 1.0
In-Reply-To: <20101002.132056.226767861.davem@davemloft.net>
References: <AANLkTimF+zy-qTmbtchGu_0Td7fZUsrsd7PNgkAdM8fA@mail.gmail.com>
	<20101002.132056.226767861.davem@davemloft.net>
Date: Sun, 3 Oct 2010 10:37:32 +0800
Message-ID: <AANLkTi=sX5gTwPdjyXAZ0Q+V45EYq7pzLoLAAZm30_cN@mail.gmail.com>
Subject: Re: Ask For Comment: add routines for exchanging data between sock
 buffer and scatter list
From: Hillf Danton <dhillf@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, robert.w.love@intel.com,
        James.Bottomley@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 3, 2010 at 4:20 AM, David Miller <davem@davemloft.net> wrote:
>
> All networking related patch postings should be sent with
> netdev@vger.kernel.org at least on the CC: list.
>

Node. And thanks for the chance to redeliver it since there is one line
messed by mailer.
And the check for the data length to be copied is added in the new version.
Hillf
