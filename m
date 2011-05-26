Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab1EZUl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:41:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932960Ab1EZUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110526203819.GA27529@mail.hallyn.com>
References: <20110526202505.GA6367@mail.hallyn.com> <BANLkTi=dhwdPGj=yU=NRaSkK-BBTPQNKOA@mail.gmail.com>
 <20110526203819.GA27529@mail.hallyn.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 13:40:45 -0700
Message-ID: <BANLkTikjL9znUnsAKhJfThEMtJ2aevAF-A@mail.gmail.com>
Subject: Re: [PATCH] Set cred->user_ns in key_replace_session_keyring
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        David Howells <dhowells@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 1:38 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>
> Stable/whoever, should I re-send this patch separately, or does this suffice?

I'll add the Cc and update the description to point to the commit it
was introduced in, and it will all be fine. Then the stable team will
get it automatically when I push out.

                          Linus
