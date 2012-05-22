Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571Ab2EVPox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:44:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36953 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2EVPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <1337671311.16400.12.camel@dabdike.int.hansenpartnership.com>
References: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
 <CA+55aFz__YrXffza1bEzwrPu+-ETswUcg3F31Gjrj3OPbRyTZw@mail.gmail.com> <1337671311.16400.12.camel@dabdike.int.hansenpartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 May 2012 08:44:30 -0700
X-Google-Sender-Auth: WNnrUQEYA7wKDo_r-uQuXskUS-o
Message-ID: <CA+55aFzHVEph_MvPjb=QiK4bg8qBDmdpzkXS4C1RCFyBDj6ecg@mail.gmail.com>
Subject: Re: [GIT PULL] First round of SCSI updates for the 3.4+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 12:21 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> You probably need to do a gpg --refresh
>
> I use the subkeys method for signing, so I have my master key (which
> expires in 2016) in one of Greg's GPG devices, but I have signing and an
> encryption subkeys which are short lived (currently expire in Oct 2012).
> If you do a gpg --list-keys 'James Bottomley' you'll see this:

Ayup, that fixed it. Really confusing how it doesn't even show the
signing key expiry date if you just look at the key ID..

                 Linus
