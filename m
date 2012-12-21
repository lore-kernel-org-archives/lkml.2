Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2LUKaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:30:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58303 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2LUKaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:30:04 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Gutierrez, Juan" <jgutierrez@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>, Tejun Heo <tj@kernel.org>,
        "Anna, Suman" <s-anna@ti.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 4/9] mailbox: create opened message type
Thread-Topic: [PATCH 4/9] mailbox: create opened message type
Thread-Index: AQHN3SJEGY59nq1a/Um05UIeNVCh75gjCfVQ
Date: Fri, 21 Dec 2012 10:28:47 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EC9CE7A@DBDE01.ent.ti.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <1355836212-17956-5-git-send-email-loic.pallardy-ext@stericsson.com>
In-Reply-To: <1355836212-17956-5-git-send-email-loic.pallardy-ext@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {35C581CE-3421-428D-8341-2666878AB8A1}
x-cr-hashedpuzzle: =?us-ascii?Q?C1Pe_Hf8c_UH3V_glvo_iYUH_il8e_ldaU_mR2R_wtLf_29li_8KWv_AB3gq?=
 =?us-ascii?B?dz09IEFIb2hydz09IEFNZks2dz09IEFNb3ZvQT09IEFSWlI4UT09OzE5O1lR?=
 =?us-ascii?Q?ByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGIAcgBvAG8AbgBpAGUAQABvAH?=
 =?us-ascii?Q?AAZQBuAHMAbwB1AHIAYwBlAC4AdwBvAGwAZgBzAG8AbgBtAGkAYwByAG8ALg?=
 =?us-ascii?Q?BjAG8AbQA7AGYAZQBsAGkAcABlAC4AYwBvAG4AdAByAGUAcgBhAHMAQABuAG?=
 =?us-ascii?Q?8AawBpAGEALgBjAG8AbQA7AGcAcgBlAGcAawBoAEAAbABpAG4AdQB4AGYAbw?=
 =?us-ascii?Q?B1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAawByAHoAeQBzAHoAdABAAH?=
 =?us-ascii?Q?QAaQBzAC4AaQBjAG4AZQB0AC4AcABsADsAbABpAG4AdQBzAC4AdwBhAGwAbA?=
 =?us-ascii?Q?BlAGkAagBAAGwAaQBuAGEAcgBvAC4AbwByAGcAOwBsAGkAbgB1AHgALQBhAH?=
 =?us-ascii?Q?IAbQAtAGsAZQByAG4AZQBsAEAAbABpAHMAdABzAC4AaQBuAGYAcgBhAGQAZQ?=
 =?us-ascii?Q?BhAGQALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAG?=
 =?us-ascii?Q?UAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBvAG0AYQ?=
 =?us-ascii?Q?BwAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AH?=
 =?us-ascii?Q?gAQABhAHIAbQAuAGwAaQBuAHUAeAAuAG8AcgBnAC4AdQBrADsAbABvAGkAYw?=
 =?us-ascii?Q?AuAHAAYQBsAGwAYQByAGQAeQAtAGUAeAB0AEAAcwB0AGUAcgBpAGMAcwBzAG?=
 =?us-ascii?Q?8AbgAuAGMAbwBtADsAbABvAGkAYwAuAHAAYQBsAGwAYQByAGQAeQBAAHMAdA?=
 =?us-ascii?Q?AuAGMAbwBtADsAbwBoAGEAZABAAHcAaQB6AGUAcgB5AC4AYwBvAG0AOwBvAG?=
 =?us-ascii?Q?0AYQByAC4AcgBhAG0AaQByAGUAegBAAGMAbwBwAGkAdABsAC4AYwBvAG0AOw?=
 =?us-ascii?Q?BwAG8AcABjAG8AcgBuAG0AaQB4AEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBzAH?=
 =?us-ascii?Q?QAZQByAGkAYwBzAHMAbwBuAF8AbgBvAG0AYQBkAGkAawBfAGwAaQBuAHUAeA?=
 =?us-ascii?Q?BAAGwAaQBzAHQALgBzAHQALgBjAG8AbQA7AHQAagBAAGsAZQByAG4AZQBsAC?=
 =?us-ascii?Q?4AbwByAGcAOwB0AG8AbgB5AEAAYQB0AG8AbQBpAGQAZQAuAGMAbwBtADsAdw?=
 =?us-ascii?Q?BpAG0AQABpAGcAdQBhAG4AYQAuAGIAZQA=3D;Sosha1=5Fv1;7;{35C581CE?=
 =?us-ascii?Q?-3421-428D-8341-2666878AB8A1};dgBhAGkAYgBoAGEAdgAuAGIAZQBkAG?=
 =?us-ascii?Q?kAYQBAAHQAaQAuAGMAbwBtAA=3D=3D;Fri,_21_Dec_2012_10:23:59_GMT?=
 =?us-ascii?Q?;UgBFADoAIABbAFAAQQBUAEMASAAgADQALwA5AF0AIABtAGEAaQBsAGIAbwB?=
 =?us-ascii?Q?4ADoAIABjAHIAZQBhAHQAZQAgAG8AcABlAG4AZQBkACAAbQBlAHMAcwBhAGc?=
 =?us-ascii?Q?AZQAgAHQAeQBwAGUA?=
x-originating-ip: [172.24.133.119]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 18:40:07, Loic Pallardy wrote:
> Current message type is a u32 to fit HW fifo format.
> This should be extended to support any message exchanges
> and type of mailbox.
> Propose structure owns the original u32 and an optional
> pointer on additional data.
> 
> Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
> ---
>  drivers/mailbox/Kconfig         |  9 ++++++
>  drivers/mailbox/mailbox-omap1.c | 18 ++++++------
>  drivers/mailbox/mailbox-omap2.c | 10 ++++---
>  drivers/mailbox/mailbox.c       | 64 +++++++++++++++++++++++++++++------------
>  drivers/mailbox/mailbox.h       |  6 ++--
>  include/linux/mailbox.h         | 17 ++++++++++-
>  6 files changed, 89 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
> index d1e7d74..efb766f 100644
> --- a/drivers/mailbox/Kconfig
> +++ b/drivers/mailbox/Kconfig
> @@ -33,4 +33,13 @@ config MBOX_KFIFO_SIZE
>           This can also be changed at runtime (via the mbox_kfifo_size
>           module parameter).
>  
> +config MBOX_DATA_SIZE
> +	int "Mailbox associated data max size (bytes)"
> +	default 64
> +	help
> +	  Specify the default size of mailbox's associated data buffer
> +	  (bytes)
> +          This can also be changed at runtime (via the mbox_kfifo_size
> +          module parameter).
> +
>  endif
> diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
> index 31cb70a..94e90af 100644
> --- a/drivers/mailbox/mailbox-omap1.c
> +++ b/drivers/mailbox/mailbox-omap1.c
> @@ -50,26 +50,26 @@ static inline void mbox_write_reg(u32 val, size_t ofs)
>  }
>  
>  /* msg */
> -static mbox_msg_t omap1_mbox_fifo_read(struct mailbox *mbox)
> +static int omap1_mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
>  {
>  	struct omap_mbox1_fifo *fifo =
>  		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
> -	mbox_msg_t msg;
>  
> -	msg = mbox_read_reg(fifo->data);
> -	msg |= ((mbox_msg_t) mbox_read_reg(fifo->cmd)) << 16;
> +	msg->header = mbox_read_reg(fifo->data);
> +	msg->header |= ((mbox_msg_t) mbox_read_reg(fifo->cmd)) << 16;

Now that struct mailbox_msg encapsulates the data, you can
get rid of the mbox_msg_t typedef completely. Having the data
as part of the mailbox_msg along with the functions with mbox_msg_t
as the return type just creates confusion IMHO.
 
>  
> -	return msg;
> +	return 0;
>  }

Convert all return 0 functions to void?

[...]

>  
> diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
> index 18c9502..d256e1a 100644
> --- a/include/linux/mailbox.h
> +++ b/include/linux/mailbox.h
> @@ -7,7 +7,22 @@ typedef int __bitwise mailbox_irq_t;
>  #define IRQ_TX ((__force mailbox_irq_t) 1)
>  #define IRQ_RX ((__force mailbox_irq_t) 2)
>  
> -int mailbox_msg_send(struct mailbox *, mbox_msg_t msg);
> +struct mailbox_msg {
> +	int		size;
> +	u32		header;
> +	void		*pdata;
> +};
> +
> +#define MAILBOX_FILL_MSG(_msg, _header, _pdata, _size) { \
> +	_msg.header = _header; \
> +	_msg.pdata = (void *)_pdata; \
> +	_msg.size = _size; \
> +}
> +
> +#define MAILBOX_FILL_HEADER_MSG(_msg, _header) \
> +	MAILBOX_FILL_MSG(_msg, _header, NULL, 0);
> +

I used these patches as part of the suspend-resume support for AM335x
which has the same mailbox IP as OMAP4. I used the MAILBOX_FILL_HEADER_MSG
helper and things work as expected.

However, I found the 'header' part to be very confusing. Why not treat the
OMAP case as a special case of the new MAILBOX_FILL_MSG where the data size
is set to 1?

Regards,
Vaibhav
