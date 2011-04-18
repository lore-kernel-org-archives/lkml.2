Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab1DRSYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 14:24:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37034 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1DRSYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 14:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nt1Ja5cLNKIq9iBaXwjx8lcyxMBRY3JZopsyetdcEUpb4b2u3joVB39h84zoyqZnkN
         B16j6mQbWSz4mn1qIh/mwnWV2hJ99UiboyiSjfGirWqlx+fTe940CJMvcZri1PBd6/yP
         kPCnm4XPaQYRNqoLriLgQBZzfaDo+xkJy/o2E=
MIME-Version: 1.0
In-Reply-To: <4DAC75C6.2060504@caviumnetworks.com>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
	<4DAC75C6.2060504@caviumnetworks.com>
Date: Mon, 18 Apr 2011 11:24:20 -0700
Message-ID: <BANLkTinbFNvez+G4LpmF7uwwJrH_J1NK8w@mail.gmail.com>
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
From: Kevin Cernekee <cernekee@gmail.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:32 AM, David Daney <ddaney@caviumnetworks.com> wrote:
> How much testing have you done on non-RI/XI CPUs?

On a non-RIXI CPU I was able to boot the system, run a basic GUI
application, create R/W shared mappings to /dev/mem, insert/remove
kernel modules, run a broken program that dumps core, etc.

I guess it would be a good idea to make sure swap still works.  Didn't
try that yet.

Can you think of anything else that might exercise the bits that were
touched by the patch?  Were there any tests you ran during the
development of RIXI support which uncovered subtle issues?

Thanks.
