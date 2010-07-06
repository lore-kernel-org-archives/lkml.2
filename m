Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0GFSWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 14:22:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34278 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab0GFSWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 14:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GecHGQ4j9zd7UzHHXGHnpyMiOOG9LSnEHhxCnDoP6jW/BRFQfkpLzBdM6nr1WRb0LT
         T2B/4a+uis9J8r5qS8Jep8DBo4ZRWcoSRnu4/p1ld4ycQK6nHYUb8savorEPBRckXYP4
         lxpTaEaVi5UniwaMlSDpkuE7GX2ACq4XhO77g=
MIME-Version: 1.0
In-Reply-To: <1278419386-8118-1-git-send-email-sjayaraman@suse.de>
References: <1278419386-8118-1-git-send-email-sjayaraman@suse.de>
Date: Tue, 6 Jul 2010 13:22:08 -0500
Message-ID: <AANLkTinmYDtq_eikwgjJSscRxJP9AvK9f2XD_tsFGtXC@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove unused ip_address field in struct 
	TCP_Server_Info
From: Steve French <smfrench@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes sense - plan to merge this and two others of yours into
cifs-2.6.git today or tomorrow.

On Tue, Jul 6, 2010 at 7:29 AM, Suresh Jayaraman <sjayaraman@suse.de> wrote:
> The ip_address field is not used and seems redundant as there is union addr
> already and I don't see any future use as well.
>
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
>  fs/cifs/cifsglob.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index a88479c..f182fe8 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -142,7 +142,6 @@ struct TCP_Server_Info {
>        struct list_head pending_mid_q;
>        void *Server_NlsInfo;   /* BB - placeholder for future NLS info  */
>        unsigned short server_codepage; /* codepage for the server    */
> -       unsigned long ip_address;       /* IP addr for the server if known */
>        enum protocolEnum protocolType;
>        char versionMajor;
>        char versionMinor;
>



-- 
Thanks,

Steve
