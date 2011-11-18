Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1KRSLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:11:48 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:36683 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750949Ab1KRSLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:11:47 -0500
Message-ID: <4EC69F65.20207@xenotime.net>
Date: Fri, 18 Nov 2011 10:09:41 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Konrad Eisele <konrad@gaisler.com>
CC: linux-kernel@vger.kernel.org,
        linux kbuild list <linux-kbuild@vger.kernel.org>, mmarek@suse.cz,
        pefoley2@verizon.net, yann.morin.1998@anciens.enib.fr,
        sam@ravnborg.org, zippel@linux-m68k.org
Subject: Re: [PATCH 1/1] kconfig: Add a configuration subtree command to kconfig
References: <1321625774-12749-1-git-send-email-konrad@gaisler.com>
In-Reply-To: <1321625774-12749-1-git-send-email-konrad@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(changed linux-config@ to linux-kbuild@vger.kernel.org)

On 11/18/2011 06:16 AM, Konrad Eisele wrote:
> New kconfig command "subsource":
> subsource "<kconfig>" "<cwd>" "<.config>" "<title>"  <internal_prefix> <.config_prefix>
> Allocates <kconfig> as a configuration subtree using <.config> as the configuration
> file to save and load from. <cwd> is the directory path to switch to for "source" to
> work, "<title>" is the Menu tile of the subtree, <internal_prefix> is a internal prefix,
> and <.config_prefix> is the prefix to append/remove when saving/loading <.config>.

That explains what but not why.  You need some justification(s) for such
a large patch.  Maybe even some example usages.

> Signed-off-by: Konrad Eisele <konrad@gaisler.com>
> ---
>  scripts/kconfig/conf.c               |    6 +-
>  scripts/kconfig/confdata.c           |   83 ++-
>  scripts/kconfig/expr.h               |   16 +
>  scripts/kconfig/gconf.c              |    3 +
>  scripts/kconfig/lkc.h                |    1 +
>  scripts/kconfig/lkc_proto.h          |   12 +-
>  scripts/kconfig/mconf.c              |   13 +-
>  scripts/kconfig/menu.c               |   18 +-
>  scripts/kconfig/nconf.c              |   13 +-
>  scripts/kconfig/qconf.cc             |    3 +
>  scripts/kconfig/symbol.c             |   50 ++-
>  scripts/kconfig/util.c               |   49 ++
>  scripts/kconfig/zconf.gperf          |    1 +
>  scripts/kconfig/zconf.hash.c_shipped |  252 +++++-----
>  scripts/kconfig/zconf.l              |   50 ++-
>  scripts/kconfig/zconf.lex.c_shipped  |   52 ++-
>  scripts/kconfig/zconf.tab.c_shipped  |  985 ++++++++++++++++++----------------
>  scripts/kconfig/zconf.y              |   23 +-
>  18 files changed, 991 insertions(+), 639 deletions(-)



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
