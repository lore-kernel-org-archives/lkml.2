Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab0CXDUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:20:16 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:23754 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab0CXDUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:20:14 -0400
From: Giridhar Malavali <giridhar.malavali@qlogic.com>
To: Ferenc Wagner <wferi@niif.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       LinuxSCSI <linux-scsi@vger.kernel.org>
Date: Tue, 23 Mar 2010 20:20:10 -0700
Subject: Re: [PATCH] qla2xxx: Fix documentation of ql2xfdmienable module
 parameter
Thread-Topic: [PATCH] qla2xxx: Fix documentation of ql2xfdmienable module
 parameter
Thread-Index: AcrKsgj/WkxZWdrZRcCqeAz04JeQeAATt/Qb
Message-ID: <C7CED2FA.5FEB%giridhar.malavali@qlogic.com>
In-Reply-To: <87634n0xkc.fsf@tac.ki.iif.hu>
Accept-Language: en-US
Content-Language: en
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 Mar 2010 03:20:14.0118 (UTC) FILETIME=[EB466C60:01CACB00]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 3/23/10 10:14 AM, "Ferenc Wagner" <wferi@niif.hu> wrote:

> The default is enabled since 7e47e5ca184548341a82eeb2238ee3622c43cae1.
> 
> Signed-off-by: Ferenc Wagner <wferi@niif.hu>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 46720b2..ac08397 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -69,8 +69,8 @@ static void qla2x00_free_device(scsi_qla_host_t *);
>  int ql2xfdmienable=1;
>  module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
>  MODULE_PARM_DESC(ql2xfdmienable,
> -               "Enables FDMI registratons "
> -               "Default is 0 - no FDMI. 1 - perfom FDMI.");
> +               "Enables FDMI registrations. "
> +               "0 - no FDMI. Default is 1 - perform FDMI.");
> 
>  #define MAX_Q_DEPTH    32
>  static int ql2xmaxqdepth = MAX_Q_DEPTH;
> --
> 1.5.6.5
> 

Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>


> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

