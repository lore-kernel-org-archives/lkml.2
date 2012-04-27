Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab2D0Prb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:47:31 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:54375 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972Ab2D0Pra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:47:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQHACxOgk8Y9geI/2dsb2JhbAANNoVzsCSCCAEDAQKEHgEBBCNVARALDgwCBRYLAgIJAwIBAgFFBg0BBwEBtCSKGIEvjhOBGASpJQ
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="177133512"
Message-ID: <4F9ABF90.5060404@teksavvy.com>
Date: Fri, 27 Apr 2012 11:47:28 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>, autofs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru> <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com> <4F9A6ABA.6050503@msgid.tls.msk.ru>
In-Reply-To: <4F9A6ABA.6050503@msgid.tls.msk.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-27 05:45 AM, Michael Tokarev wrote:
..
> Please note: the talk is about 32bit userspace on 64bit kernel,
> which should be quite rare these days, or something of less
> priority.


I suspect 32bit-PAE is more common than 32/64,
but both are valid and not uncommon in the wild.
