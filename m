Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab1HBQFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:05:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52082 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1HBQFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vFT6daeE+5EsbDtEeUV-sYZgcMQd_=GSR+kqre7Opkgw@mail.gmail.com>
References: <CACxGe6vFT6daeE+5EsbDtEeUV-sYZgcMQd_=GSR+kqre7Opkgw@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 2 Aug 2011 17:05:11 +0100
X-Google-Sender-Auth: 0Q1fG0v2g_dQKqYZfUcZtvfVNro
Message-ID: <CACxGe6sp9U1KB51C-5V2Xb02gDSQXGpouyrPg6tZgOQgc8TE8g@mail.gmail.com>
Subject: Re: [GIT PULL] device tree fixes for v3.1
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, missed one patch.  Here's an updated pull req that includes a
MAINTAINERS file change.

g.

The following changes since commit 5f66d2b58ca879e70740c82422354144845d6dd3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
(2011-08-01 06:14:25 -1000)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/next

Felipe Balbi (1):
      of: address: use resource_size helper

Jamie Iles (1):
      of: constify property name parameters for helper functions

Mark Brown (1):
      MAINTAINERS: Add keyword match for of_match_table to device tree section

Michal Simek (1):
      input: xilinx_ps2: Add missing of_address.h header

 MAINTAINERS                      |    1 +
 drivers/input/serio/xilinx_ps2.c |    2 +-
 drivers/of/address.c             |    2 +-
 drivers/of/base.c                |    7 ++++---
 include/linux/of.h               |   15 +++++++++------
 5 files changed, 16 insertions(+), 11 deletions(-)


On Tue, Aug 2, 2011 at 4:54 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Not much here to talk about here.  Pretty boring stuff.
>
> g.
>
> The following changes since commit 5f66d2b58ca879e70740c82422354144845d6dd3:
>
>  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
> (2011-08-01 06:14:25 -1000)
>
> are available in the git repository at:
>
>  git://git.secretlab.ca/git/linux-2.6 devicetree/next
>
> Felipe Balbi (1):
>      of: address: use resource_size helper
>
> Jamie Iles (1):
>      of: constify property name parameters for helper functions
>
> Michal Simek (1):
>      input: xilinx_ps2: Add missing of_address.h header
>
>  drivers/input/serio/xilinx_ps2.c |    2 +-
>  drivers/of/address.c             |    2 +-
>  drivers/of/base.c                |    7 ++++---
>  include/linux/of.h               |   15 +++++++++------
>  4 files changed, 15 insertions(+), 11 deletions(-)
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
