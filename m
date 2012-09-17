Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2IQHlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:41:37 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57476 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2IQHlf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 17 Sep 2012 03:41:35 -0400
Message-Id: <5056F04B020000780009BAF9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 17 Sep 2012 08:41:31 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@kernel.org>
Cc: <tglx@linutronix.de>, <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
References: <504DEA1B020000780009A277@nat28.tlf.novell.com>
 <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
 <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
In-Reply-To: <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.09.12 at 23:14, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Thu, Sep 13, 2012 at 11:23 PM, tip-bot for Jan Beulich
> <JBeulich@suse.com> wrote:
>>
>> x86: Prefer TZCNT over BFS
> 
> This patch is insane.

I'm not going to defend this simple and strait forward a patch to
such a reply, so Ingo, just drop it to please Linus, even though I
can't see what's _this_ bad about it.

Jan

