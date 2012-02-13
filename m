Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2BMRUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:20:25 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:55628 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755503Ab2BMRUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:20:23 -0500
Message-ID: <4F394635.6030707@xenotime.net>
Date: Mon, 13 Feb 2012 09:19:49 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: trivial@kernel.org, lucas.demarchi@profusion.mobi,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [trivial] Documentation: broken URL in filesystems
References: <1329124192-27461-1-git-send-email-michael.opdenacker@free-electrons.com> <1329124192-27461-2-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1329124192-27461-2-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 01:09 AM, Michael Opdenacker wrote:
> Fix broken link in Documentation/filesystem, replacing
> ftp://ftp.uk.linux.org/pub/linux/sct/fs/jfs/journal-design.ps.gz
> by a URL on http://boot.kernel.org

Please drop the "boot." portion.  It is not needed.

http://kernel.org/pub/linux/kernel/people/sct/ext3/
works fine.

> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  Documentation/DocBook/filesystems.tmpl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/filesystems.tmpl b/Documentation/DocBook/filesystems.tmpl
> index f51f285..2b3de6d 100644
> --- a/Documentation/DocBook/filesystems.tmpl
> +++ b/Documentation/DocBook/filesystems.tmpl
> @@ -387,7 +387,7 @@ an example.
>       <title>See also</title>
>  	<para>
>  	  <citation>
> -	   <ulink url="ftp://ftp.uk.linux.org/pub/linux/sct/fs/jfs/journal-design.ps.gz">
> +	   <ulink url="http://boot.kernel.org/pub/linux/kernel/people/sct/ext3/journal-design.ps.gz">
>  	   	Journaling the Linux ext2fs Filesystem, LinuxExpo 98, Stephen Tweedie
>  	   </ulink>
>  	  </citation>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
