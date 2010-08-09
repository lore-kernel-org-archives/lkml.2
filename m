Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0HIFSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:18:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57243 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab0HIFSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <1281327087.2168.67.camel@pasglop>
References: <1281327087.2168.67.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 8 Aug 2010 23:18:19 -0600
X-Google-Sender-Auth: xkvQUHJRbBDBC-Pnefpip2yCCU0
Message-ID: <AANLkTin0dkWPkU3C47HjnxZ2e_ujCUfNUp4xm_xSX3yK@mail.gmail.com>
Subject: Re: [git pull] Please pull powerpc.git next branch
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 8, 2010 at 10:11 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> Hi Linus !
>
> Here's a few misc things for .36. The big bit is that I trimmed all the
> defconfigs using make savedefconfig.
[...]
>  108 files changed, 270 insertions(+), 134609 deletions(-)

And how is anyone else to make it into the kernel statistics top
contributors by lines changed list with stuff like this going in?  :-)

g.
