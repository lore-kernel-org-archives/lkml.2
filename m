Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2G3Km4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:42:56 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59689 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2G3Kmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <500D1116.7070301@parallels.com>
References: <500D09C9.7060903@parallels.com>
	<500D1116.7070301@parallels.com>
Date: Mon, 30 Jul 2012 12:42:54 +0200
Message-ID: <CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, lwn@lwn.net,
        "criu@openvz.org" <criu@openvz.org>, users@openvz.org,
        Containers <containers@lists.linux-foundation.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 10:53 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
> This project is an attempt to implement the checkpoint-restore functionality
> for processes and containers without driving too much code into the kernel tree,
> but putting there "various oddball helper code" instead.

Is CRIU able to checkpoint a process tree where one or more processes
are traced using ptrace()?
crtools seem to use ptrace() to execute parasite system calls.
AFAIK this will only work if the target process is currently not
ptraced() by another process.

-- 
Thanks,
//richard
