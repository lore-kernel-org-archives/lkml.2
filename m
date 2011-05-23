Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab1EWVAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:00:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54913 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030232Ab1EWVAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sz/N/rHOljgRdigbHZwASA9Ag8TSwtWmrjrsTcXxaoPiwBGrpMqcTiTmiGndrX1Gr2
         QVOhbewxj+Tej8hFVoxqja7PoBS7/1mwRposW+tmYhxOxTRA5KTYhhjdhJruHbd8yCVa
         X1lnc3sOt7KbmmlCu9ua2UIbaBWm8syaFARs4=
MIME-Version: 1.0
In-Reply-To: <1306184186-11551-1-git-send-email-nab@linux-iscsi.org>
References: <1306184186-11551-1-git-send-email-nab@linux-iscsi.org>
Date: Mon, 23 May 2011 23:00:45 +0200
Message-ID: <BANLkTi=LZLL5srnGuHaFnViq8Mtk2-kXFw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add drivers/target/ entry
From: Fubo Chen <fubo.chen@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 10:56 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  MAINTAINERS |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 20be668..a831859 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> +TARGET SUBSYSTEM
> +M:     Nicholas A. Bellinger <nab@linux-iscsi.org>
> +L:     linux-scsi@vger.kernel.org
> +L:     http://groups.google.com/group/linux-iscsi-target-dev
> +W:     http://www.linux-iscsi.org
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
> +S:     Supported
> +F:     drivers/target/
> +F:     include/target/

No documentation for drivers/target ?

Fubo.
