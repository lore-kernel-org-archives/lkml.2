Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab0GVD1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 23:27:51 -0400
Received: from xenotime.net ([72.52.115.56]:54203 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752231Ab0GVD1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 23:27:47 -0400
Date: Wed, 21 Jul 2010 20:27:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25]Documentation/DocBook/scsi.tmpl update web
 address.
Message-Id: <20100721202743.072dfc5b.rdunlap@xenotime.net>
In-Reply-To: <1279687926-29360-10-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
	<1279687926-29360-10-git-send-email-justinmattock@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 21:52:01 -0700 Justin P. Mattock wrote:

> The patch below updates a broken web address.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  Documentation/DocBook/scsi.tmpl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/scsi.tmpl b/Documentation/DocBook/scsi.tmpl
> index d87f456..324b534 100644
> --- a/Documentation/DocBook/scsi.tmpl
> +++ b/Documentation/DocBook/scsi.tmpl
> @@ -393,7 +393,7 @@
>          </para>
>          <para>
>            For documentation see
> -          <ulink url='http://www.torque.net/sg/sdebug26.html'>http://www.torque.net/sg/sdebug26.html</ulink>
> +          <ulink url='http://sg.danny.cz/sg/sdebug26.html'>http://sg.danny.cz/sg/sdebug26.html</ulink>
>          </para>
>  <!-- !Edrivers/scsi/scsi_debug.c -->
>        </sect2>
> -- 

Thanks, good catch.  I changed most of those...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
