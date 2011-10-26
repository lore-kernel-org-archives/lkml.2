Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1JZSro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 14:47:44 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49748 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932774Ab1JZSrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 14:47:42 -0400
Message-ID: <4EA855C6.806@xenotime.net>
Date: Wed, 26 Oct 2011 11:47:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        bluesmoke-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: linux-next: Tree for Oct 25 (sb_edac.c)
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
In-Reply-To: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/11 02:36, Stephen Rothwell wrote:
> Hi all,


sb_edac.c:(.text.unlikely+0x8370): undefined reference to `x86_mce_decoder_chain'
sb_edac.c:(.text.unlikely+0x87aa): undefined reference to `x86_mce_decoder_chain'



when CONFIG_X86_MCE is not enabled.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
