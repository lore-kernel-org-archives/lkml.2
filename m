Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1J2BBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 21:01:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34344 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1J2BBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 21:01:15 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Blake <eblake@redhat.com>
Subject: Re: rename("a", "b") would not always remove "a" on success. ?!!
Date: Sat, 29 Oct 2011 03:00:57 +0200
User-Agent: KMail/1.8.2
Cc: =?iso-8859-1?q?P=E1draig_Brady?= <P@draigbrady.com>,
        Coreutils <coreutils@gnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christian Engelmayer <christian.engelmayer@frequentis.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <CAK1hOcN1ocnFh+HJWMONbUmoGtnxGvfrkxjRVs8zNmurz1xdrA@mail.gmail.com> <4EAACAF0.4030401@draigBrady.com> <4EAACD51.5060703@redhat.com>
In-Reply-To: <4EAACD51.5060703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201110290300.57778.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 October 2011 17:42, Eric Blake wrote:
> On 10/28/2011 09:32 AM, Pádraig Brady wrote:
> >> http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html
> >>
> >> 'If the old argument and the new argument resolve to either .... or different
> >> directory entries for the same existing file, rename() shall return
> >> successfully and perform no other action.'
> >>
> >> It's incredible they had audacity to put such nonsense into standard.
> >>
> >> The page says in "RATIONALE" section:
> >>
> >> 'The specification that if old and new refer to the same file is
> >> intended to guarantee that:
> >>
> >> rename("x", "x");
> >>
> >> does not remove the file.'
> >>
> >> Why didn't they just explicitly say that they actually want THIS
> >> particular case to work correctly, not OTHER cases to be fucked up?!
> 
> Because it is historical precedent, and changing it now would break 
> software that has come to expect this behavior on hard links.

There is centain level of absurdity, after which fixing a goof in standards
makes sense even if it theoretically can break some existing program.

In my opinion, the key word here is "theoritically".
Is there even one real-world program which depends on this?
I bet there is not.

-- 
vda
