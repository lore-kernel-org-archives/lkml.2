Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2AMBrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:47:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51211 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2AMBrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:47:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAPXgP120MoEUK9vSiELx4nzkL9X3w=YBgXGs3Q-VPm-4ZjgvZQ@mail.gmail.com>
References: <20120106201126.GA7239@kroah.com> <CA+55aFzH1cqoxr5RR8yqPdjf4XphKHk9YmcDozPn_z7Aq3nDcg@mail.gmail.com>
 <CAPXgP120MoEUK9vSiELx4nzkL9X3w=YBgXGs3Q-VPm-4ZjgvZQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jan 2012 17:46:53 -0800
X-Google-Sender-Auth: bAlPq8xLg_rBLW_rGpmv0OMlplU
Message-ID: <CA+55aFyOcdCyo3y5vJ-3uL2BLLH5ubA81Ns-xLWBZkLf=JDzBQ@mail.gmail.com>
Subject: Re: [GIT PATCH] driver core merge for 3.3
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 5:39 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
> Maybe you can check if the suspend problem goes away if you disable
> CONFIG_X86_MCE?

It does. So there is something wrong with MCE. It causes the second
suspend to hang for me. Disabling X86_MCE makes it work.

(I have other problems on that machine too, but they are unrelated)

                Linus
