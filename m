Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2IWTnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:43:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54146 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754189Ab2IWTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:43:23 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18VgzM6zOAVA/izf+UlR9U/wKNhKH1tgCY3VDQWKa
	PwrMNYjKIqQ5CY
Message-ID: <505F6652.7050207@gmx.de>
Date: Sun, 23 Sep 2012 19:43:14 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Thomas Winischhofer <thomas@winischhofer.net>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] drivers/video/sis/initextlfb.c: removes unnecessary
 semicolon
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com> <1346947757-10481-8-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1346947757-10481-8-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 04:09 PM, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> removes unnecessary semicolon
> 
> Found by Coccinelle: http://coccinelle.lip6.fr/
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/sis/initextlfb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/drivers/video/sis/initextlfb.c b/drivers/video/sis/initextlfb.c
> --- a/drivers/video/sis/initextlfb.c
> +++ b/drivers/video/sis/initextlfb.c
> @@ -65,7 +65,7 @@ sisfb_mode_rate_to_dclock(struct SiS_Pri
>      }
>  #endif
>  
> -    if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) {;
> +    if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) {
>         printk(KERN_ERR "Could not find mode %x\n", ModeNo);
>         return 65000;
>      }
> 
> 

