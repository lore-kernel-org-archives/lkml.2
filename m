Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1LEW4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 17:56:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53334 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab1LEW4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 17:56:02 -0500
Date: Mon, 5 Dec 2011 14:55:32 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Vasiliy Kulikov <segooon@gmail.com>
cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg KH <greg@kroah.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC v2 2/3] procfs: add hidepid= and gid= mount options
In-Reply-To: <20111119110212.GB11468@albatros>
Message-ID: <alpine.LSU.2.00.1112051451470.3938@sister.anvils>
References: <20111119110126.GA11468@albatros> <20111119110212.GB11468@albatros>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011, Vasiliy Kulikov wrote:
> This patch adds support of mount options to restrict access to
> /proc/PID/ directories.  The default backward-compatible "relaxed"
> behaviour is left untouched.

This patch, in 3.2.0-rc3-next-20111202, leaks tasks: watch
while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done

Hugh
