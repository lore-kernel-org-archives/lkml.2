Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2BMRXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:23:13 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:50823 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751227Ab2BMRXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:23:11 -0500
Message-ID: <4F3946DC.3090102@xenotime.net>
Date: Mon, 13 Feb 2012 09:22:36 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: trivial@kernel.org, lucas.demarchi@profusion.mobi,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2/2] [trivial] Documentation: broken URL in libata
References: <1329124192-27461-1-git-send-email-michael.opdenacker@free-electrons.com> <1329124192-27461-3-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1329124192-27461-3-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 01:09 AM, Michael Opdenacker wrote:
> Fix broken link to license text:
> http://www.opensource.org/licenses/osl-1.1.txt
> The text for version 1.1 of the Open Sofware license doesn't seem
> to be available anywhere on http://www.opensource.org/ any more.
> Replace it with a snapshot from the Internet Wayback Machine.

That's one option.
Too bad opensource.org doesn't provide archives.

OSL v1.1 is also available here:
http://fedoraproject.org/wiki/Licensing:OSL1.1

and here:
http://www.samurajdata.se/opensource/mirror/licenses/osl.php

Jeff, I don't suppose there is any chance of changing this file's license?
(since the Debian people found it to be a problem .. long ago)


> I first thought about hosting a copy of this file on my
> own website, but my website has less authority than
> an explicit backup of the original location.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  Documentation/DocBook/libata.tmpl |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
> index cdd1bb9..bda33c1 100644
> --- a/Documentation/DocBook/libata.tmpl
> +++ b/Documentation/DocBook/libata.tmpl
> @@ -22,8 +22,8 @@
>     <para>
>     The contents of this file are subject to the Open
>     Software License version 1.1 that can be found at
> -   <ulink url="http://www.opensource.org/licenses/osl-1.1.txt">http://www.opensource.org/licenses/osl-1.1.txt</ulink> and is included herein
> -   by reference.
> +   <ulink url="http://web.archive.org/web/20060924133258/http://www.opensource.org/licenses/osl-1.1.txt">http://web.archive.org/web/20060924133258/http://www.opensource.org/licenses/osl-1.1.txt</ulink>
> +   and is included herein by reference.
>     </para>
>  
>     <para>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
