Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab0G0WGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 18:06:47 -0400
Received: from xenotime.net ([72.52.115.56]:48055 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751331Ab0G0WGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 18:06:46 -0400
Date: Tue, 27 Jul 2010 15:06:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Charles =?ISO-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>,
        trivial@kernel.org
Cc: <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        rydberg@euromail.se
Subject: Re: [PATCH] Fix bcm5974 documentation link
Message-Id: <20100727150635.1dc1b2f5.rdunlap@xenotime.net>
In-Reply-To: <1280221397-2416-1-git-send-email-caratorn@gmail.com>
References: <1280221397-2416-1-git-send-email-caratorn@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 11:03:17 +0200 Charles Clément wrote:

> 
> Signed-off-by: Charles Clément <caratorn@gmail.com>
> ---
>  Documentation/input/bcm5974.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/input/bcm5974.txt b/Documentation/input/bcm5974.txt
> index 5e22dcf..74d3876 100644
> --- a/Documentation/input/bcm5974.txt
> +++ b/Documentation/input/bcm5974.txt
> @@ -62,4 +62,4 @@ Links
>  -----
>  
>  [1] http://ubuntuforums.org/showthread.php?t=840040
> -[2] http://http://bitmath.org/code/
> +[2] http://bitmath.org/code/
> -- 

Thanks.  This one is already fixed in a large URL check/fix patchset from
Justin P. Mattock on FRI July-23-2010.  I expect that the trivial tree
maintainer will merge that one.[1]


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***


1:
From:	"Justin P. Mattock" <justinmattock@gmail.com>
To:	trivial@kernel.org
Cc:	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz, "Justin P. Mattock" <justinmattock@gmail.com>, Thomas Weber <weber@corscience.de>, Mike Frysinger <vapier.adi@gmail.com>, Paulo Marques <pmarques@grupopie.com>, Randy Dunlap <rdunlap@xenotime.net>, Michael Neuling <mikey@neuling.org>
Subject: [PATCH]Documentation update broken web addresses.
Date:	Fri, 23 Jul 2010 20:51:24 -0700
