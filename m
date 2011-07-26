Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1GZU4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:56:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42226 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1GZU4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:56:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110726205121.GA29604@dumpdata.com>
References: <20110725155442.GA21759@dumpdata.com> <20110725161009.GA9193@dumpdata.com>
 <CAObL_7F9+Wn1DBf5te7BHoAe3CbEzR=pxTqy_S_vpkwcG57NKQ@mail.gmail.com>
 <20110726161808.GA5333@dumpdata.com> <CAObL_7Fi5F6Xxv7Z5UtEQAA+gH4429gN=GG8ur6rxa6-rgr+2w@mail.gmail.com>
 <20110726205121.GA29604@dumpdata.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 26 Jul 2011 16:55:57 -0400
X-Google-Sender-Auth: 60msorqNhR-HvT_NqEDnuE8nKYA
Message-ID: <CAObL_7Fiv9kkSeu5qkq3GubbWvykHLpVzurpeJQ9WoSR=XR5xA@mail.gmail.com>
Subject: Re: git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7 (x86-64: Give
 vvars their own page) breaks Xen PV guests (64-bit).
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jj@chaosbits.net, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, arjan@infradead.org,
        JBeulich@novell.com, richard.weinberger@gmail.com, mikpe@it.uu.se,
        andi@firstfloor.org, brgerst@gmail.com, Louis.Rilling@kerlabs.com,
        Valdis.Kletnieks@vt.edu, pageexec@freemail.hu, mingo@elte.hu,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 4:51 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> That one means that the vvar fixmap isn't working.  Can you try the
>> attached patch?
>
> Sure. Albeit it looks to be missing a check for the 0xe033 cs?

Sorry -- I meant can you try that on top of the 0xe033 hack?

--Andy
