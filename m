Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1JLWAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:00:04 -0400
Received: from ozlabs.org ([203.10.76.45]:59005 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab1JLWAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:00:03 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Cc: lennart@poettering.net, harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Jon Masters <jcm@jonmasters.org>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99s?= Wish List for Linux
In-Reply-To: <1317943022.1095.25.camel@mop>
References: <1317943022.1095.25.camel@mop>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Sun, 09 Oct 2011 19:15:47 +1030
Message-ID: <8762jyft8k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Oct 2011 01:17:02 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> * module-init-tools: provide a proper libmodprobe.so from
> module-init-tools:
> Early boot tools, installers, driver install disks want to access
> information about available modules to optimize bootup handling.

That's a bit too vague for my limited experience and/or lack of
imagination: what exactly do they want?  And why?

Thanks,
Rusty.
