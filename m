Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1GaSIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 14:08:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53455 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab1GaSIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 14:08:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=EB8s9HD+blP7QxNNVInWYVae9eqQ6O+GF30c76Gb1n0uvDCi5LmqAr2WJKN0ZOrw7
	bTc3YpUAD9+iRUVHghQ4w==
MIME-Version: 1.0
In-Reply-To: <20110730235644.GA29671@suse.de>
References: <20110729180028.6a2091b3.rdunlap@xenotime.net> <20110730235644.GA29671@suse.de>
From: Mike Waychison <mikew@google.com>
Date: Sun, 31 Jul 2011 11:07:48 -0700
Message-ID: <CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 4:56 PM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jul 29, 2011 at 06:00:28PM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Introduce "Internal-reference-ID:" for company-internal
>> patch tracking.  Also clarify that URLs in patches should be
>> public, not private.
>>
>> Based on emails from Greg Kroah-Hartman.
>>
>> Internal-reference-ID: rdunlap.2011.0729.id1
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Mike Waychison <mikew@google.com>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Theodore Tso <tytso@MIT.EDU>
>> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>

Acked-by: Mike Waychison <mikew@google.com>
