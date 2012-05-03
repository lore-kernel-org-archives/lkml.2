Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab2ECS1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:27:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50991 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab2ECS1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:27:21 -0400
Message-ID: <4FA2CDFC.6070901@zytor.com>
Date: Thu, 03 May 2012 11:27:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@gmail.com>,
        Jana Saout <jana@saout.de>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
References: <1335788867.29087.19.camel@localhost> <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com> <1335875321.26671.15.camel@localhost> <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com> <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com> <20120503064722.GN6871@ZenIV.linux.org.uk> <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com> <CA+55aFxeBHSB6iBpP55kV2bLQGg8ZC9Ve5mvCmZN0ARH9dVwKg@mail.gmail.com> <4FA2CAD9.6010808@zytor.com> <CA+55aFxrBghonjRvS=KK=5Oqw_Wj9PDh2wkDtVh7U9jw8=uTsA@mail.gmail.com>
In-Reply-To: <CA+55aFxrBghonjRvS=KK=5Oqw_Wj9PDh2wkDtVh7U9jw8=uTsA@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 11:23 AM, Linus Torvalds wrote:
> 
> I left the instruction suffixes in place, although Peter is probably
> right that the assembler will do the right thing.
> 

Yes, and we have <asm/asm.h> for the case where it doesn't (where there
is only a memory operand, for example.)  I tend to put the suffixes in
even if they are redundant, but we already rely on the unsuffixed
instructions working in many, many places.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

