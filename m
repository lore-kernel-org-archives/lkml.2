Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1ELRLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:11:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57841 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033Ab1ELRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=S83rIYxPmJWZLBS6PN/JHbtDLYtFn9vG8iJRPz5n0Xj+IsjXwXJnP4OqRWGbWtJ17u
         8O/uSXdBDcf3B5RlKjKN17ztSPqBhFwMioNfVzs1XNaZvIp1qk3oZnyZAn0YqdtWEBwc
         onhBCh3TaC7N2ztpkFvEsgEg7qPtTN7DUz/EE=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	<1305127773-10570-4-git-send-email-mgorman@suse.de>
	<alpine.DEB.2.00.1105120942050.24560@router.home>
	<1305213359.2575.46.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121024350.26013@router.home>
	<1305214993.2575.50.camel@mulgrave.site>
	<20110512154649.GB4559@redhat.com>
	<1305216023.2575.54.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121121120.26013@router.home>
	<1305217843.2575.57.camel@mulgrave.site>
	<BANLkTi=MD+voG1i7uDyueV22_daGHPRdqw@mail.gmail.com>
Date: Thu, 12 May 2011 20:11:05 +0300
X-Google-Sender-Auth: ZW5ucF_orEUb8MfC8YfrAPVRdRE
Message-ID: <BANLkTimDsJDht76Vm7auNqT2gncjpEKZQw@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
From: Pekka Enberg <penberg@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Christoph Lameter <cl@linux.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 8:06 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Thu, May 12, 2011 at 7:30 PM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> So suggest an alternative root cause and a test to expose it.
>
> Is your .config available somewhere, btw?

If it's this:

http://pkgs.fedoraproject.org/gitweb/?p=kernel.git;a=blob_plain;f=config-x86_64-generic;hb=HEAD

I'd love to see what happens if you disable

CONFIG_TRANSPARENT_HUGEPAGE=y

because that's going to reduce high order allocations as well, no?

                        Pekka
