Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031186Ab2CVVzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:55:00 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36771 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030475Ab2CVVy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:54:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120322214157.GB12985@phenom.dumpdata.com>
References: <20120322183845.GA17264@phenom.dumpdata.com> <20120322200918.GZ6589@ZenIV.linux.org.uk>
 <20120322202445.GB6589@ZenIV.linux.org.uk> <20120322203658.GC6589@ZenIV.linux.org.uk>
 <20120322214157.GB12985@phenom.dumpdata.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 14:54:37 -0700
X-Google-Sender-Auth: QXiwB8l3C1RLfyEusgcgZWPRaYU
Message-ID: <CA+55aFxBS3bJoB8BiUR3Ni2KqpK5ofxSBC9+LcgRRoxYGAMKjQ@mail.gmail.com>
Subject: Re: Regression introduced by bfcfaa77bdf0f775263e906015982a608df01c76
 (vfs: use 'unsigned long' accesses for dcache name comparison and hashing)
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 2:41 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> Works for me! Thanks for coming up with a patch so quickly. Please add
>
> Reported-and-Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Goodie. Al, I can commit it as yours, but I'd want a sign-off and a
commit message for that. Otherwise I'll take credit..

                Linus
