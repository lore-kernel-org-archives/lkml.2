Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1GHVrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:47:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54412 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1GHVrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:47:06 -0400
MIME-Version: 1.0
In-Reply-To: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
Date: Fri, 8 Jul 2011 17:47:05 -0400
Message-ID: <CACqU3MUrCODMx=8Bu+YDxy2BJwjm-77PXFob5OwHn=fr5mTdkg@mail.gmail.com>
Subject: Re: [RFC 0/4] streamline_config clean-ups
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 1, 2011 at 7:31 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> The following series attempts to merge some redundants stuff in the kconfig
> Makefile, namely how streamline_config learns about its environment, avoids
> multi-line shell command in kconfig's Makefile. Seconds commit also removes the
> non-portable usage of sed(1) as -i is not POSIX compliant.
>
> Comments appreciated!
>
>  - Arnaud
>
Ping ?

Thanks,
 - Arnaud

> ps: I'm not really a huge fan of the direct export of MAKECMDGOALS, maybe should
> it be KBUILD_MAKECMDGOALS.
>
> Arnaud Lacombe (4):
>  kbuild: export MAKECMDGOALS
>  kconfig/streamline_config.pl: directly access LSMOD
>  kconfig/streamline_config.pl: merge local{mod,yes}config
>  kconfig/streamline_config.pl: move config generation to script
>
>  Makefile                             |    3 ++
>  scripts/kconfig/Makefile             |   40 +--------------------------------
>  scripts/kconfig/localconfig.sh       |   20 +++++++++++++++++
>  scripts/kconfig/streamline_config.pl |   19 +++++++++++++--
>  4 files changed, 41 insertions(+), 41 deletions(-)
>  create mode 100755 scripts/kconfig/localconfig.sh
>
> --
> 1.7.3.4.574.g608b.dirty
>
>
