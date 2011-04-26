Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab1DZGkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:40:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40987 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab1DZGkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I5GPGXtqrOaozAWrArVDOyCUB2aXjQzjr6r4AQmkXwc4u3g98EOyRWHr2gel2DZ25W
         nQXrxX1iXigcwxXaOPsLR7v8D+/oek3jphgkCTXs/9NhUEInnECPRWY85yeGYt3oagFQ
         U68RdcIp2V96fRQ7Xghhl+Q2jLmKYfC02yAs0=
MIME-Version: 1.0
In-Reply-To: <4DB608EE.1060502@verizon.net>
References: <4DB608EE.1060502@verizon.net>
Date: Tue, 26 Apr 2011 02:40:03 -0400
Message-ID: <BANLkTi=sjE-YF1+q1++Bk78n4bvs6W5Wgg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: fix sed error in export_report.pl
From: Arnaud Lacombe <lacombar@gmail.com>
To: pefoley2@verizon.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 25, 2011 at 7:51 PM, Peter Foley <pefoley2@verizon.net> wrote:
> This patch fixes a sed error in export_report.pl by escaping a $.
>
Which error ?

Thanks,
 - Arnaud

> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/export_report.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/export_report.pl b/scripts/export_report.pl
> index 04dce7c..91fa5a2 100644
> --- a/scripts/export_report.pl
> +++ b/scripts/export_report.pl
> @@ -50,7 +50,7 @@ sub usage {
>  sub collectcfiles {
>     my @file
> -       = `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko$/.mod.c/`;
> +       = `cat .tmp_versions/*.mod | grep '.*\.ko\$' | sed s/\.ko\$/.mod.c/`;
>     chomp @file;
>     return @file;
>  }
> --
> 1.7.5.rc1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
