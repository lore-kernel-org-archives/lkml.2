Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1GaSK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 14:10:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38060 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab1GaSKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 14:10:21 -0400
Message-ID: <4E359A74.7090408@zytor.com>
Date: Sun, 31 Jul 2011 11:09:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Greg KH <gregkh@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Documentation: add Internal-reference-ID: patch tag
References: <20110729180028.6a2091b3.rdunlap@xenotime.net> <20110730235644.GA29671@suse.de> <CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com>
In-Reply-To: <CAGTjWtDXeMnHWZMmRezTSYmHr3D1N1KRXzzdjQh9HJMxvj8pwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2011 11:07 AM, Mike Waychison wrote:
>>>
>>> Internal-reference-ID: rdunlap.2011.0729.id1
>>>
> 
> Acked-by: Mike Waychison <mikew@google.com>
> 

Just to avoid namespace collisions, can we at least put the owner
somewhere standardized, e.g. <2011.0729.id1@rdunlap>, <33999@google> and
so on?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

