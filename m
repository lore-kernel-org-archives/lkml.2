Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1CVOyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:54:03 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62721 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1CVOyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=B2BaKZYK2E6cuxELKrDWerHdGVaNk2xdMZGWCcDi5onjSCMeQe9699RNu1A3DvYnwo
         Q8KHhW/gNoJlP2S1+nipNqAn+78wtQO/zvhoHzWz+c4YqmA1NgFFa6C+qtn8CL3WWXcD
         iFNNOIGGLYrguHveQoJALPUJgq9uq+U/M3wDc=
MIME-Version: 1.0
In-Reply-To: <1296607359-19332-1-git-send-email-vapier@gentoo.org>
References: <1294656834-6293-1-git-send-email-vapier@gentoo.org> <1296607359-19332-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 22 Mar 2011 10:53:38 -0400
X-Google-Sender-Auth: yJQry7ormCRbxJOIzc9bYr1Cs6M
Message-ID: <AANLkTi=Cj0qZOEYsHCqkgotBwuZkgzNAT9zKd-+JfpAm@mail.gmail.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: reset rpt_cleaners warnings
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 19:42, Mike Frysinger wrote:
> If you run checkpatch against multiple patches, and one of them has a
> whitespace issue which can be helped via a script (rpt_cleaners), you
> will see the same NOTE over and over for all subsequent patches.  It
> makes it seem like those patches also have whitespace problems when in
> reality, there's only one or two bad apples.
>
> So reset rpt_cleaners back to 0 after we've issued the note so that it
> only shows up near the patch with the actual problems.

ping ...
-mike
