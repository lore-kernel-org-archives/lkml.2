Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1BMWM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:12:57 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33991 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab1BMWMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i7BPEeJ1UEG/ZcmkwhQA4Eg+QJf4TDlEfnnNDBVL/oKhU7A8Dl9yOdvLgpBrcelWYw
         WqfqeB4JAFSrIfoAT+LUjsnvKYEFdYPkxXNqUqjeWmNTtA+hYtmopLM7N4MzameovW1Q
         /f5nGlS+lSVlrFnbKqAwEAPKRmlTEdmPkflew=
MIME-Version: 1.0
In-Reply-To: <4D58551C.40105@zytor.com>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>
	<201102132110.29630.arnd@arndb.de>
	<AANLkTimZA1Npf0nJ8PF-2=8Oe2LXr_ShyBJNkf8Dn5S5@mail.gmail.com>
	<4D584A49.80306@zytor.com>
	<AANLkTikbFM5BjcD1=KsO-tHpHn-01Sxnqp40_GtbifYY@mail.gmail.com>
	<4D58551C.40105@zytor.com>
Date: Sun, 13 Feb 2011 14:12:51 -0800
Message-ID: <AANLkTimZFdMT77h5mP3C1wvhhp+TgZSQLjdgXWpdQwDK@mail.gmail.com>
Subject: Re: X32 psABI status
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x32-abi@googlegroups.com, Arnd Bergmann <arnd@arndb.de>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 2:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/13/2011 01:28 PM, H.J. Lu wrote:
>>
>> That is is currently implemented on hjl/x32 branch.
>>
>> I also added
>>
>> __NR_sigaction
>> __NR_sigpending
>> __NR_sigprocmask
>> __NR_sigsuspend
>>
>> to help the Bionic C library.
>>
>
> That seems a little redundant... even on the i386 front we want people
> to use the rt_sig* system calls.  As a porting aid I can see it, but we
> should avoid deprecated system calls in the final version.
>

That is the plan. I don't want to spend more time on fixing the
Bionic C library. Once x32 glibc is running, I will remove those
ia32 system calls.

-- 
H.J.
