Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab2EVAw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 20:52:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39189 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab2EVAwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 20:52:53 -0400
MIME-Version: 1.0
In-Reply-To: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
References: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 17:52:31 -0700
X-Google-Sender-Auth: NMQLxCjEwWtGimIQtmwWgLs82xU
Message-ID: <CA+55aFz__YrXffza1bEzwrPu+-ETswUcg3F31Gjrj3OPbRyTZw@mail.gmail.com>
Subject: Re: [GIT PULL] First round of SCSI updates for the 3.4+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 4:30 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> The patch contains the usual assortment of driver updates (be2iscsi,
> bfa, bnx2i, fcoe, hpsa, isci, lpfc, megaraid, mpt2sas, pm8001, sg) plus
> an assortment of other changes and fixes.  Also new is the fact that the
> isci update is delivered as a git merge (with signed tag).

Interesting. For some reason the 'gpg --verify' phase says that your
key has expired. Yet when I look at the key itself, it says it is
valid until 2016. I don't quite know why gpg thinks the thing is
expired when verifying the message.

But everything else looks fine. Somebody with more gpg-fu than me
might be able to clarify what is going on..

                  Linus
