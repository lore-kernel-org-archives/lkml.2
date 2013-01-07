Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3AGBiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:38:15 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:53923 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3AGBiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:38:12 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <878v854wx1.fsf@rustcorp.com.au>
References: <CAKgNAkjF+9d3_UhzOM-1H+F9W6UAhWDnugS__XzFiL-b2a3gyQ@mail.gmail.com>
 <878v854wx1.fsf@rustcorp.com.au>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 7 Jan 2013 02:37:51 +0100
Message-ID: <CAKgNAkjEQwcLkJ3EWsxKm3hD_LXg7zVRofyS_J+=oLja=LnoHQ@mail.gmail.com>
Subject: Re: init_module.2 man page ERRORS text for signed modules
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Mon, Jan 7, 2013 at 2:14 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>
>> Hi David, Rusty,
>>
>> Linux 3.7 added signed modules. As a consequence, init_module()
>> acquired some new possible error returns. I've put together the text
>> below to describe the new errors. Does the text look okay?
>
> Looks good.  I liked the finit_module text, too.

Okay -- thanks for checking the text!

Cheers,

Michael

PS See you in Canberra!


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
