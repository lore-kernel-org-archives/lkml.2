Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2EBLpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:45:43 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47771 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2EBLpm (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 2 May 2012 07:45:42 -0400
Message-ID: <4FA11E59.9050004@suse.com>
Date: Wed, 02 May 2012 17:15:29 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>, Jeff Layton <jlayton@redhat.com>,
        linux-cifs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
References: <20120427081815.4478.26011.stgit@perseus.themaw.net> <CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com> <CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com>
In-Reply-To: <CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2012 09:03 AM, Steve French wrote:
> The fix makes sense, but it is fairly recent and I haven't had a
> chance to try it,
> so unless a new release is imminent, I would prefer to put in the next merge
> request (I have at least one more fix likely as well) next week.

We need this fix for -stable as well, right? Please include

   Cc: stable@vger.kernel.org


Suresh


