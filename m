Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab0FTA3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 20:29:42 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:37329 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0FTA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 20:29:35 -0400
X-Authority-Analysis: v=1.0 c=1 a=E6DmO_SAt5MA:10 a=ood2b7iyd8MA:10 a=kj9zAlcOel0A:10 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=VwQbUJbxAAAA:8 a=voM4FWlXAAAA:8 a=meeJQD-LrWseRLbJceIA:9 a=Azpe9r4v0dia6O8oR8sA:7 a=WfflI4xHP6dxe-i053MsA1GD_YoA:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Sat, 19 Jun 2010 20:28:31 -0400
From: Jeff Layton <jlayton@samba.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       linux-cifs@vger.kernel.org
Subject: Re: [PATCH]MAINTAINERS update e-mail address
Message-ID: <20100619202831.042adeaf@tlielax.poochiereds.net>
In-Reply-To: <1276981011-25092-1-git-send-email-justinmattock@gmail.com>
References: <1276981011-25092-1-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010 13:56:51 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> get_maintainer.pl did it's job.. just the MAINTAINERS
> file need to be updated or else you get this:
> subject:Auto-response for your message to the "linux-cifs-client" mailing list
> 
> The linux-cifs-client@lists.samba.org mailing list is now deprecated.
> The new mailing list is linux-cifs@vger.kernel.org. Subscription is no
> longer required to post to that list. Please resend your message
> there.
> 
> so update the linux-cifs address in the MAINTAINERS file.
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6d119c9..8d6a3ff 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1581,7 +1581,7 @@ F:	include/linux/coda*.h
>  
>  COMMON INTERNET FILE SYSTEM (CIFS)
>  M:	Steve French <sfrench@samba.org>
> -L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
> +L:	linux-cifs@vger.kernel.org	
>  L:	samba-technical@lists.samba.org (moderated for non-subscribers)
>  W:	http://linux-cifs.samba.org/
>  Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/


Thanks. I sent a patch to update this a week or two ago, but it hasn't
made it into mainline yet. I believe Steve F. is going to push the
patch there.

-- 
Jeff Layton <jlayton@samba.org>
