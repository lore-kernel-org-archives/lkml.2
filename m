Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2HNLyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:54:46 -0400
Received: from seven.medozas.de ([5.9.24.206]:48701 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab2HNLyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:54:45 -0400
Date: Tue, 14 Aug 2012 13:54:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: =?UTF-8?Q?J=C3=B6rn_Engel?= <joern@logfs.org>
cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
In-Reply-To: <20120718185335.GA1771@logfs.org>
Message-ID: <alpine.LNX.2.01.1208141353360.30904@frira.zrqbmnf.qr>
References: <20120424205946.GH20610@logfs.org> <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com> <20120425132513.GA23492@logfs.org> <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com> <20120712174633.GA7248@logfs.org> <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org> <20120716124614.GA19497@x1.osrc.amd.com> <20120718185335.GA1771@logfs.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2012-07-18 20:53, Jörn Engel wrote:
>
>> With the include added, it builds fine. Then I took an usb stick and I
>> did:
>> 
>> $ ./mkblockconsole /dev/sdc
>> 
>> <reboot>
>
>You can also run hdparm -z <dev> instead.

We have too many ways of doing some things.
util-linux conveniently has `blockdev --rereadpt /dev/sdc`.
