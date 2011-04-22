Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1DVSqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 14:46:46 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:55729 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858Ab1DVSqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 14:46:42 -0400
Subject: Re: End of FAT directories (added missing reference)
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: linux kernel FAT <hirofumi@mail.parknet.co.jp>
Cc: dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1303498136.8485.128.camel@localhost>
References: <1303498136.8485.128.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 20:51:08 +0200
Message-ID: <1303498268.8485.130.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 87.123.66.109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 22.04.2011, 20:48 +0200 schrieb Michael Karcher:
> Hello Linux FAT developers and developers of related tools,
> 
> there seem to be different interpretations around how to read a FAT
> directory that contains an entry starting with a NUL byte before further
> entries *NOT* starting with NUL bytes. I uploaded an example image of
> this type to [1]. It contains three zero-byte files "WINDOWS", "IS",
> "GREAT", an empty directory slot and a file with contents named "NOT".
[1]: http://users.physik.fu-berlin.de/~mkarcher/fatimg.gz


