Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1E2WTi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 18:19:38 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:43200 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab1E2WTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 18:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=augustl.com; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=AzVVwy0n5fBqnNApYQ8bULAy5uzniheeta/QnOYh2dDBPauVaGakFh64GTDHZJBSO5
         cELlEoQpa9VovayGmpw1DPEa17217A2qmgvrLEWu45HeCgkA015nnJRMd/Rw3bXlR/HJ
         Du8Zeh2hELcqab4N6Hzcy542VQz0n2yNhHYUA=
MIME-Version: 1.0
In-Reply-To: <BANLkTinoaAt4YamyDoOGbsDhCMBGZhz_rw@mail.gmail.com>
References: <1306688839-18732-1-git-send-email-august@augustl.com>
 <20110529234416.7f6f2d53@stein> <BANLkTinoaAt4YamyDoOGbsDhCMBGZhz_rw@mail.gmail.com>
From: August Lilleaas <august@augustl.com>
Date: Mon, 30 May 2011 00:19:17 +0200
Message-ID: <BANLkTinSueVgV1xyLVo1nycnLm4VJOyTtA@mail.gmail.com>
Subject: [PATCH] Firewire: net: replacing deprecated __attribute__((packed))
 with __packed
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding as plain text, mistakenly sent as HTML mail first.

---------- Forwarded message ----------
From: August Lilleaas <august@augustl.com>
Date: Mon, May 30, 2011 at 12:11 AM
Subject: Re: [PATCH] Firewire: net: replacing deprecated
__attribute__((packed)) with __packed
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org


On Sun, May 29, 2011 at 11:44 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
>
> Who deprecated it and why?

To be frank, the motivation for this patch was a message from
script/checkpatch.pl when scouring random files for warnings. (This is
my first contribution to the kernel.)
Just did some much needed investigation though. It was deprecated for
portability, specifically to avoid GCC specific code. See commit
82ddcb040570411fc2d421d96b3e69711c670328.

>
> Shouldn't you add "#include <linux/compiler.h>" now?

You're right. I'll read up on updating patches and get at it.

>
> --
> Stefan Richter
> -=====-==-== -=-= ===-=
> http://arcgraph.de/sr/
