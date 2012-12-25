Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2LYLRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:17:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39333 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab2LYLRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:17:44 -0500
Date: Tue, 25 Dec 2012 12:17:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: bbi5291 <bbi5291@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does init start with any open files?
Message-ID: <20121225111742.GB7720@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	bbi5291 <bbi5291@gmail.com>, linux-kernel@vger.kernel.org
References: <CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMmfjbPKGD28070A0JvMyL02juYW5tuwNmVwrJ-1gFzkNhCuDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 02:38:09AM -0500, bbi5291 wrote:
> When the init process is created on system startup, does it have any
> open file descriptors? If so, where do they point?

$ tree /proc/1/fd
/proc/1/fd
└── 10 -> /run/initctl

0 directories, 1 file

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
