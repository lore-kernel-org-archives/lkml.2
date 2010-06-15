Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab0FOIuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:50:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44313 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab0FOIul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:50:41 -0400
Message-ID: <4C173EDB.1000001@mev.co.uk>
Date: Tue, 15 Jun 2010 09:50:35 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100422 Thunderbird/3.0.4
MIME-Version: 1.0
To: Gustavo Silva <silvagustavosilva@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
       "wfp5p@virginia.edu" <wfp5p@virginia.edu>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "silvagustavo@users.sourceforge.net" 
	<silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH] Staging: comedi: drivers: fix coding style issues in
 	pcl812.c
References: <1276399541-12127-1-git-send-email-silvagustavo@users.sourceforge.net>	<4C1600C5.2000907@mev.co.uk> <AANLkTil7zflTT8Af4YSkhiIHlFH-H9lSqzoOTtO_zD85@mail.gmail.com>
In-Reply-To: <AANLkTil7zflTT8Af4YSkhiIHlFH-H9lSqzoOTtO_zD85@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/06/10 06:43, Gustavo Silva wrote:
> 2010/6/14 Ian Abbott <abbotti@mev.co.uk>:
>> On 13/06/10 04:25, Gustavo Silva wrote:
>>> + * Driver: pcl812
>>> + * Description: Advantech PCL-812/PG, PCL-813/B,
>>> + *          ADLink ACL-8112DG/HG/PG, ACL-8113, ACL-8216,
>>> + *          ICP DAS A-821PGH/PGL/PGL-NDA, A-822PGH/PGL, A-823PGH/PGL, A-826PG,
>>> + *          ICP DAS ISO-813
>>> + * Author: Michal Dobes <dobes@tesnet.cz>
>>> + * Devices: [Advantech] PCL-812 (pcl812), PCL-812PG (pcl812pg),
>>> + * PCL-813 (pcl813), PCL-813B (pcl813b), [ADLink] ACL-8112DG (acl8112dg),
>>> + * ACL-8112HG (acl8112hg), ACL-8113 (acl-8113), ACL-8216 (acl8216),
>>> + * [ICP] ISO-813 (iso813), A-821PGH (a821pgh), A-821PGL (a821pgl),
>>> + * A-821PGL-NDA (a821pclnda), A-822PGH (a822pgh), A-822PGL (a822pgl),
>>> + * A-823PGH (a823pgh), A-823PGL (a823pgl), A-826PG (a826pg)
>>
>> Please add extra whitespace (a tab or a couple of spaces) to the
>> "Devices:" continuation lines here, e.g.:
>>
>>  * Devices: [Advantech] PCL-812 (pcl812), PCL-812PG (pcl812pg),
>>  *   PCL-813 (pcl813), PCL-813B (pcl813b), [ADLink] ACL-8112DG (acl8112dg),
>>  *   ACL-8112HG (acl8112hg), ACL-8113 (acl-8113), ACL-8216 (acl8216),
>>  *   [ICP] ISO-813 (iso813), A-821PGH (a821pgh), A-821PGL (a821pgl),
>>  *   A-821PGL-NDA (a821pclnda), A-822PGH (a822pgh), A-822PGL (a822pgl),
>>  *   A-823PGH (a823pgh), A-823PGL (a823pgl), A-826PG (a826pg)
>>
>> This extra whitespace is for the benefit of some scripts we have in
>> comedi and comedilib for extracting the documentation.  (Actually, these
>> scripts don't handle the " * " at the beginning of the line yet, but I'm
>> working on that!)
>>
>> Thanks.
>>
>> --
>> -=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
>> -=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
>>
> 
> Hi Ian,
> 
> Thanks for your comments,
> let me known if this OK for you now.
> 
> Best Regards,
> Gus.

Hi Gus,

It looks fine.  You can add my signed-off-by line if you want to.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>

> This is a patch to the pcl812.c file that fixes up the following
> issues:
> 
> ERROR: code indent should use tabs where possible                  x 27
> WARNING: line over 80 characters                                   x 37
> WARNING: please, no space before tabs                              x 13
> WARNING: braces {} are not necessary for single statement blocks   x  2
> WARNING: printk() should include KERN_ facility level              x 22
> WARNING: braces {} are not necessary for any arm of this statement x  5
> 
> Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
> ---
>  drivers/staging/comedi/drivers/pcl812.c |  476 +++++++++++++++++--------------
>  1 files changed, 259 insertions(+), 217 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcl812.c
> b/drivers/staging/comedi/drivers/pcl812.c
> index 1ddc19c..1ea239a 100644
> --- a/drivers/staging/comedi/drivers/pcl812.c
> +++ b/drivers/staging/comedi/drivers/pcl812.c
> @@ -15,97 +15,98 @@
>   *  card:   A-823PGH, A-823PGL, A-826PG
>   * driver:  a823pgh,  a823pgl,  a826pg
>   */
> +
>  /*
> -Driver: pcl812
> -Description: Advantech PCL-812/PG, PCL-813/B,
> -             ADLink ACL-8112DG/HG/PG, ACL-8113, ACL-8216,
> -             ICP DAS A-821PGH/PGL/PGL-NDA, A-822PGH/PGL, A-823PGH/PGL, A-826PG,
> -             ICP DAS ISO-813
> -Author: Michal Dobes <dobes@tesnet.cz>
> -Devices: [Advantech] PCL-812 (pcl812), PCL-812PG (pcl812pg),
> -  PCL-813 (pcl813), PCL-813B (pcl813b), [ADLink] ACL-8112DG (acl8112dg),
> -  ACL-8112HG (acl8112hg), ACL-8113 (acl-8113), ACL-8216 (acl8216),
> -  [ICP] ISO-813 (iso813), A-821PGH (a821pgh), A-821PGL (a821pgl),
> -  A-821PGL-NDA (a821pclnda), A-822PGH (a822pgh), A-822PGL (a822pgl),
> -  A-823PGH (a823pgh), A-823PGL (a823pgl), A-826PG (a826pg)
> -Updated: Mon, 06 Aug 2007 12:03:15 +0100
> -Status: works (I hope. My board fire up under my hands
> -               and I cann't test all features.)
> -
> -This driver supports insn and cmd interfaces. Some boards support only insn
> -becouse their hardware don't allow more (PCL-813/B, ACL-8113, ISO-813).
> -Data transfer over DMA is supported only when you measure only one
> -channel, this is too hardware limitation of these boards.
> -
> -Options for PCL-812:
> -  [0] - IO Base
> -  [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7; 10, 11, 12, 14, 15)
> -  [2] - DMA  (0=disable, 1, 3)
> -  [3] - 0=trigger source is internal 8253 with 2MHz clock
> -        1=trigger source is external
> -  [4] - 0=A/D input range is +/-10V
> -        1=A/D input range is +/-5V
> -        2=A/D input range is +/-2.5V
> -        3=A/D input range is +/-1.25V
> -        4=A/D input range is +/-0.625V
> -        5=A/D input range is +/-0.3125V
> -  [5] - 0=D/A outputs 0-5V  (internal reference -5V)
> -        1=D/A outputs 0-10V (internal reference -10V)
> -        2=D/A outputs unknown (external reference)
> -
> -Options for PCL-812PG, ACL-8112PG:
> -  [0] - IO Base
> -  [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7; 10, 11, 12, 14, 15)
> -  [2] - DMA  (0=disable, 1, 3)
> -  [3] - 0=trigger source is internal 8253 with 2MHz clock
> -        1=trigger source is external
> -  [4] - 0=A/D have max +/-5V input
> -        1=A/D have max +/-10V input
> -  [5] - 0=D/A outputs 0-5V  (internal reference -5V)
> -        1=D/A outputs 0-10V (internal reference -10V)
> -        2=D/A outputs unknown (external reference)
> -
> -Options for ACL-8112DG/HG, A-822PGL/PGH, A-823PGL/PGH, ACL-8216, A-826PG:
> -  [0] - IO Base
> -  [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7; 10, 11, 12, 14, 15)
> -  [2] - DMA  (0=disable, 1, 3)
> -  [3] - 0=trigger source is internal 8253 with 2MHz clock
> -        1=trigger source is external
> -  [4] - 0=A/D channels are S.E.
> -        1=A/D channels are DIFF
> -  [5] - 0=D/A outputs 0-5V  (internal reference -5V)
> -        1=D/A outputs 0-10V (internal reference -10V)
> -        2=D/A outputs unknown (external reference)
> -
> -Options for A-821PGL/PGH:
> -  [0] - IO Base
> -  [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7)
> -  [2] - 0=A/D channels are S.E.
> -        1=A/D channels are DIFF
> -  [3] - 0=D/A output 0-5V  (internal reference -5V)
> -        1=D/A output 0-10V (internal reference -10V)
> -
> -Options for A-821PGL-NDA:
> -  [0] - IO Base
> -  [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7)
> -  [2] - 0=A/D channels are S.E.
> -        1=A/D channels are DIFF
> -
> -Options for PCL-813:
> -  [0] - IO Base
> -
> -Options for PCL-813B:
> -  [0] - IO Base
> -  [1] - 0= bipolar inputs
> -        1= unipolar inputs
> -
> -Options for ACL-8113, ISO-813:
> -  [0] - IO Base
> -  [1] - 0= 10V bipolar inputs
> -        1= 10V unipolar inputs
> -        2= 20V bipolar inputs
> -        3= 20V unipolar inputs
> -*/
> + * Driver: pcl812
> + * Description: Advantech PCL-812/PG, PCL-813/B,
> + *          ADLink ACL-8112DG/HG/PG, ACL-8113, ACL-8216,
> + *          ICP DAS A-821PGH/PGL/PGL-NDA, A-822PGH/PGL, A-823PGH/PGL, A-826PG,
> + *          ICP DAS ISO-813
> + * Author: Michal Dobes <dobes@tesnet.cz>
> + * Devices: [Advantech] PCL-812 (pcl812), PCL-812PG (pcl812pg),
> + *     PCL-813 (pcl813), PCL-813B (pcl813b), [ADLink] ACL-8112DG (acl8112dg),
> + *     ACL-8112HG (acl8112hg), ACL-8113 (acl-8113), ACL-8216 (acl8216),
> + *     [ICP] ISO-813 (iso813), A-821PGH (a821pgh), A-821PGL (a821pgl),
> + *     A-821PGL-NDA (a821pclnda), A-822PGH (a822pgh), A-822PGL (a822pgl),
> + *     A-823PGH (a823pgh), A-823PGL (a823pgl), A-826PG (a826pg)
> + * Updated: Mon, 06 Aug 2007 12:03:15 +0100
> + * Status: works (I hope. My board fire up under my hands
> + *            and I cann't test all features.)
> + *
> + * This driver supports insn and cmd interfaces. Some boards support only insn
> + * becouse their hardware don't allow more (PCL-813/B, ACL-8113, ISO-813).
> + * Data transfer over DMA is supported only when you measure only one
> + * channel, this is too hardware limitation of these boards.
> + *
> + * Options for PCL-812:
> + *   [0] - IO Base
> + *   [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7; 10, 11, 12, 14, 15)
> + *   [2] - DMA  (0=disable, 1, 3)
> + *   [3] - 0=trigger source is internal 8253 with 2MHz clock
> + *         1=trigger source is external
> + *   [4] - 0=A/D input range is +/-10V
> + *        1=A/D input range is +/-5V
> + *        2=A/D input range is +/-2.5V
> + *        3=A/D input range is +/-1.25V
> + *        4=A/D input range is +/-0.625V
> + *        5=A/D input range is +/-0.3125V
> + *   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
> + *        1=D/A outputs 0-10V (internal reference -10V)
> + *        2=D/A outputs unknown (external reference)
> + *
> + * Options for PCL-812PG, ACL-8112PG:
> + *   [0] - IO Base
> + *   [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7; 10, 11, 12, 14, 15)
> + *   [2] - DMA  (0=disable, 1, 3)
> + *   [3] - 0=trigger source is internal 8253 with 2MHz clock
> + *        1=trigger source is external
> + *   [4] - 0=A/D have max +/-5V input
> + *        1=A/D have max +/-10V input
> + *   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
> + *        1=D/A outputs 0-10V (internal reference -10V)
> + *        2=D/A outputs unknown (external reference)
> + *
> + * Options for ACL-8112DG/HG, A-822PGL/PGH, A-823PGL/PGH, ACL-8216, A-826PG:
> + *   [0] - IO Base
> + *   [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7; 10, 11, 12, 14, 15)
> + *   [2] - DMA  (0=disable, 1, 3)
> + *   [3] - 0=trigger source is internal 8253 with 2MHz clock
> + *        1=trigger source is external
> + *   [4] - 0=A/D channels are S.E.
> + *        1=A/D channels are DIFF
> + *   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
> + *        1=D/A outputs 0-10V (internal reference -10V)
> + *        2=D/A outputs unknown (external reference)
> + *
> + * Options for A-821PGL/PGH:
> + *   [0] - IO Base
> + *   [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7)
> + *   [2] - 0=A/D channels are S.E.
> + *        1=A/D channels are DIFF
> + *   [3] - 0=D/A output 0-5V  (internal reference -5V)
> + *        1=D/A output 0-10V (internal reference -10V)
> + *
> + * Options for A-821PGL-NDA:
> + *   [0] - IO Base
> + *   [1] - IRQ  (0=disable, 2, 3, 4, 5, 6, 7)
> + *   [2] - 0=A/D channels are S.E.
> + *        1=A/D channels are DIFF
> + *
> + * Options for PCL-813:
> + *   [0] - IO Base
> + *
> + * Options for PCL-813B:
> + *   [0] - IO Base
> + *   [1] - 0= bipolar inputs
> + *        1= unipolar inputs
> + *
> + * Options for ACL-8113, ISO-813:
> + *   [0] - IO Base
> + *   [1] - 0= 10V bipolar inputs
> + *        1= 10V unipolar inputs
> + *        2= 20V bipolar inputs
> + *        3= 20V unipolar inputs
> + */
> 
>  #include <linux/interrupt.h>
>  #include <linux/gfp.h>
> @@ -117,49 +118,50 @@ Options for ACL-8113, ISO-813:
> 
>  #include "8253.h"
> 
> -#undef PCL812_EXTDEBUG         /* if this is defined then a lot of messages
> is printed */
> +/* if this is defined then a lot of messages is printed */
> +#undef PCL812_EXTDEBUG
> 
>  /* hardware types of the cards */
> -#define boardPCL812PG           0      /* and ACL-8112PG */
> -#define boardPCL813B            1
> -#define boardPCL812             2
> -#define boardPCL813             3
> -#define boardISO813             5
> -#define boardACL8113            6
> -#define boardACL8112            7      /* ACL-8112DG/HG, A-822PGL/PGH, A-823PGL/PGH */
> -#define boardACL8216            8      /* and ICP DAS A-826PG */
> -#define boardA821               9      /* PGH, PGL, PGL/NDA versions */
> -
> -#define PCLx1x_IORANGE                 16
> -
> -#define PCL812_CTR0             0
> -#define PCL812_CTR1             1
> -#define PCL812_CTR2             2
> -#define PCL812_CTRCTL           3
> -#define PCL812_AD_LO            4
> -#define PCL812_DA1_LO           4
> -#define PCL812_AD_HI            5
> -#define PCL812_DA1_HI           5
> -#define PCL812_DA2_LO           6
> -#define PCL812_DI_LO            6
> -#define PCL812_DA2_HI           7
> -#define PCL812_DI_HI            7
> -#define PCL812_CLRINT           8
> -#define PCL812_GAIN             9
> -#define PCL812_MUX             10
> -#define PCL812_MODE            11
> -#define PCL812_CNTENABLE       10
> -#define PCL812_SOFTTRIG        12
> -#define PCL812_DO_LO           13
> -#define PCL812_DO_HI           14
> -
> -#define PCL812_DRDY            0x10    /* =0 data ready */
> -
> -#define ACL8216_STATUS                  8      /* 5. bit signalize data ready */
> -
> -#define ACL8216_DRDY           0x20    /* =0 data ready */
> -
> -#define MAX_CHANLIST_LEN       256     /* length of scan list */
> +#define boardPCL812PG        0 /* and ACL-8112PG */
> +#define boardPCL813B         1
> +#define boardPCL812          2
> +#define boardPCL813          3
> +#define boardISO813          5
> +#define boardACL8113         6
> +#define boardACL8112         7 /* ACL-8112DG/HG, A-822PGL/PGH, A-823PGL/PGH */
> +#define boardACL8216         8 /* and ICP DAS A-826PG */
> +#define boardA821            9 /* PGH, PGL, PGL/NDA versions */
> +
> +#define PCLx1x_IORANGE      16
> +
> +#define PCL812_CTR0          0
> +#define PCL812_CTR1          1
> +#define PCL812_CTR2          2
> +#define PCL812_CTRCTL        3
> +#define PCL812_AD_LO         4
> +#define PCL812_DA1_LO        4
> +#define PCL812_AD_HI         5
> +#define PCL812_DA1_HI        5
> +#define PCL812_DA2_LO        6
> +#define PCL812_DI_LO         6
> +#define PCL812_DA2_HI        7
> +#define PCL812_DI_HI         7
> +#define PCL812_CLRINT        8
> +#define PCL812_GAIN          9
> +#define PCL812_MUX          10
> +#define PCL812_MODE         11
> +#define PCL812_CNTENABLE     10
> +#define PCL812_SOFTTRIG             12
> +#define PCL812_DO_LO        13
> +#define PCL812_DO_HI        14
> +
> +#define PCL812_DRDY       0x10 /* =0 data ready */
> +
> +#define ACL8216_STATUS       8 /* 5. bit signalize data ready */
> +
> +#define ACL8216_DRDY      0x20 /* =0 data ready */
> +
> +#define MAX_CHANLIST_LEN    256        /* length of scan list */
> 
>  static const struct comedi_lrange range_pcl812pg_ai = { 5, {
>                                                             BIP_RANGE(5),
> @@ -466,10 +468,13 @@ static int pcl812_ai_insn_read(struct comedi_device *dev,
>         int n;
>         int timeout, hi;
> 
> -       outb(devpriv->mode_reg_int | 1, dev->iobase + PCL812_MODE);     /*
> select software trigger */
> -       setup_range_channel(dev, s, insn->chanspec, 1); /*  select channel
> and renge */
> +       /* select software trigger */
> +       outb(devpriv->mode_reg_int | 1, dev->iobase + PCL812_MODE);
> +       /*  select channel and renge */
> +       setup_range_channel(dev, s, insn->chanspec, 1);
>         for (n = 0; n < insn->n; n++) {
> -               outb(255, dev->iobase + PCL812_SOFTTRIG);       /* start conversion */
> +               /* start conversion */
> +               outb(255, dev->iobase + PCL812_SOFTTRIG);
>                 udelay(5);
>                 timeout = 50;   /* wait max 50us, it must finish under 33us */
>                 while (timeout--) {
> @@ -501,10 +506,13 @@ static int acl8216_ai_insn_read(struct comedi_device *dev,
>         int n;
>         int timeout;
> 
> -       outb(1, dev->iobase + PCL812_MODE);     /* select software trigger */
> -       setup_range_channel(dev, s, insn->chanspec, 1); /*  select channel
> and renge */
> +       /* select software trigger */
> +       outb(1, dev->iobase + PCL812_MODE);
> +       /*  select channel and renge */
> +       setup_range_channel(dev, s, insn->chanspec, 1);
>         for (n = 0; n < insn->n; n++) {
> -               outb(255, dev->iobase + PCL812_SOFTTRIG);       /* start conversion */
> +               /* start conversion */
> +               outb(255, dev->iobase + PCL812_SOFTTRIG);
>                 udelay(5);
>                 timeout = 50;   /* wait max 50us, it must finish under 33us */
>                 while (timeout--) {
> @@ -558,9 +566,8 @@ static int pcl812_ao_insn_read(struct comedi_device *dev,
>         int chan = CR_CHAN(insn->chanspec);
>         int i;
> 
> -       for (i = 0; i < insn->n; i++) {
> +       for (i = 0; i < insn->n; i++)
>                 data[i] = devpriv->ao_readback[chan];
> -       }
> 
>         return i;
>  }
> @@ -608,14 +615,15 @@ static int pcl812_do_insn_bits(struct comedi_device *dev,
>  */
>  static void pcl812_cmdtest_out(int e, struct comedi_cmd *cmd)
>  {
> -       printk("pcl812 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
> +       printk(KERN_INFO "pcl812 e=%d startsrc=%x scansrc=%x convsrc=%x\n", e,
>                cmd->start_src, cmd->scan_begin_src, cmd->convert_src);
> -       printk("pcl812 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
> +       printk(KERN_INFO "pcl812 e=%d startarg=%d scanarg=%d convarg=%d\n", e,
>                cmd->start_arg, cmd->scan_begin_arg, cmd->convert_arg);
> -       printk("pcl812 e=%d stopsrc=%x scanend=%x\n", e, cmd->stop_src,
> -              cmd->scan_end_src);
> -       printk("pcl812 e=%d stoparg=%d scanendarg=%d chanlistlen=%d\n", e,
> -              cmd->stop_arg, cmd->scan_end_arg, cmd->chanlist_len);
> +       printk(KERN_INFO "pcl812 e=%d stopsrc=%x scanend=%x\n", e,
> +              cmd->stop_src, cmd->scan_end_src);
> +       printk(KERN_INFO "pcl812 e=%d stoparg=%d scanendarg=%d "
> +              "chanlistlen=%d\n", e, cmd->stop_arg, cmd->scan_end_arg,
> +              cmd->chanlist_len);
>  }
>  #endif
> 
> @@ -645,11 +653,11 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
>                 err++;
> 
>         tmp = cmd->convert_src;
> -       if (devpriv->use_ext_trg) {
> +       if (devpriv->use_ext_trg)
>                 cmd->convert_src &= TRIG_EXT;
> -       } else {
> +       else
>                 cmd->convert_src &= TRIG_TIMER;
> -       }
> +
>         if (!cmd->convert_src || tmp != cmd->convert_src)
>                 err++;
> 
> @@ -673,7 +681,10 @@ static int pcl812_ai_cmdtest(struct comedi_device *dev,
>                 return 1;
>         }
> 
> -       /* step 2: make sure trigger sources are unique and mutually compatible */
> +       /*
> +        * step 2: make sure trigger sources are
> +        * unique and mutually compatible
> +        */
> 
>         if (cmd->start_src != TRIG_NOW) {
>                 cmd->start_src = TRIG_NOW;
> @@ -807,7 +818,7 @@ static int pcl812_ai_cmd(struct comedi_device
> *dev, struct comedi_subdevice *s)
>         struct comedi_cmd *cmd = &s->async->cmd;
> 
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: BGN: pcl812_ai_cmd(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: BGN: pcl812_ai_cmd(...)\n");
>  #endif
> 
>         if (cmd->start_src != TRIG_NOW)
> @@ -842,13 +853,15 @@ static int pcl812_ai_cmd(struct comedi_device
> *dev, struct comedi_subdevice *s)
>         devpriv->ai_n_chan = cmd->chanlist_len;
>         memcpy(devpriv->ai_chanlist, cmd->chanlist,
>                sizeof(unsigned int) * cmd->scan_end_arg);
> -       setup_range_channel(dev, s, devpriv->ai_chanlist[0], 1);        /*  select
> first channel and range */
> +       /*  select first channel and range */
> +       setup_range_channel(dev, s, devpriv->ai_chanlist[0], 1);
> 
>         if (devpriv->dma) {     /*  check if we can use DMA transfer */
>                 devpriv->ai_dma = 1;
>                 for (i = 1; i < devpriv->ai_n_chan; i++)
>                         if (devpriv->ai_chanlist[0] != devpriv->ai_chanlist[i]) {
> -                               devpriv->ai_dma = 0;    /*  we cann't use DMA :-( */
> +                               /*  we cann't use DMA :-( */
> +                               devpriv->ai_dma = 0;
>                                 break;
>                         }
>         } else
> @@ -869,14 +882,18 @@ static int pcl812_ai_cmd(struct comedi_device
> *dev, struct comedi_subdevice *s)
>         devpriv->ai_poll_ptr = 0;
>         s->async->cur_chan = 0;
> 
> -       if ((devpriv->ai_flags & TRIG_WAKE_EOS)) {      /*  don't we want wake up
> every scan? */
> +       /*  don't we want wake up every scan? */
> +       if ((devpriv->ai_flags & TRIG_WAKE_EOS)) {
>                 devpriv->ai_eos = 1;
> +
> +               /*  DMA is useless for this situation */
>                 if (devpriv->ai_n_chan == 1)
> -                       devpriv->ai_dma = 0;    /*  DMA is useless for this situation */
> +                       devpriv->ai_dma = 0;
>         }
> 
>         if (devpriv->ai_dma) {
> -               if (devpriv->ai_eos) {  /*  we use EOS, so adapt DMA buffer to one scan */
> +               /*  we use EOS, so adapt DMA buffer to one scan */
> +               if (devpriv->ai_eos) {
>                         devpriv->dmabytestomove[0] =
>                             devpriv->ai_n_chan * sizeof(short);
>                         devpriv->dmabytestomove[1] =
> @@ -894,9 +911,17 @@ static int pcl812_ai_cmd(struct comedi_device
> *dev, struct comedi_subdevice *s)
>                         if (devpriv->ai_neverending) {
>                                 devpriv->dma_runs_to_end = 1;
>                         } else {
> -                               bytes = devpriv->ai_n_chan * devpriv->ai_scans *
> sizeof(short);  /*  how many samples we must transfer? */
> -                               devpriv->dma_runs_to_end = bytes / devpriv->dmabytestomove[0];  /*
>  how many DMA pages we must fill */
> -                               devpriv->last_dma_run = bytes % devpriv->dmabytestomove[0];     /* on
> last dma transfer must be moved */
> +                               /*  how many samples we must transfer? */
> +                               bytes = devpriv->ai_n_chan *
> +                                       devpriv->ai_scans * sizeof(short);
> +
> +                               /*  how many DMA pages we must fill */
> +                               devpriv->dma_runs_to_end =
> +                                       bytes / devpriv->dmabytestomove[0];
> +
> +                               /* on last dma transfer must be moved */
> +                               devpriv->last_dma_run =
> +                                       bytes % devpriv->dmabytestomove[0];
>                                 if (devpriv->dma_runs_to_end == 0)
>                                         devpriv->dmabytestomove[0] =
>                                             devpriv->last_dma_run;
> @@ -934,14 +959,13 @@ static int pcl812_ai_cmd(struct comedi_device
> *dev, struct comedi_subdevice *s)
>                 break;
>         }
> 
> -       if (devpriv->ai_dma) {
> -               outb(devpriv->mode_reg_int | 2, dev->iobase + PCL812_MODE);     /*  let's go! */
> -       } else {
> -               outb(devpriv->mode_reg_int | 6, dev->iobase + PCL812_MODE);     /*  let's go! */
> -       }
> +       if (devpriv->ai_dma)                                    /*  let's go! */
> +               outb(devpriv->mode_reg_int | 2, dev->iobase + PCL812_MODE);
> +       else                                                    /*  let's go! */
> +               outb(devpriv->mode_reg_int | 6, dev->iobase + PCL812_MODE);
> 
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: END: pcl812_ai_cmd(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: END: pcl812_ai_cmd(...)\n");
>  #endif
> 
>         return 0;
> @@ -983,7 +1007,8 @@ static irqreturn_t interrupt_pcl812_ai_int(int
> irq, void *d)
> 
>         if (err) {
>                 printk
> -                   ("comedi%d: pcl812: (%s at 0x%lx) A/D cmd IRQ without DRDY!\n",
> +                   ("comedi%d: pcl812: (%s at 0x%lx) "
> +                    "A/D cmd IRQ without DRDY!\n",
>                      dev->minor, dev->board_name, dev->iobase);
>                 pcl812_ai_cancel(dev, s);
>                 s->async->events |= COMEDI_CB_EOA | COMEDI_CB_ERROR;
> @@ -1009,7 +1034,8 @@ static irqreturn_t interrupt_pcl812_ai_int(int
> irq, void *d)
>         if (next_chan == 0) {   /* one scan done */
>                 devpriv->ai_act_scan++;
>                 if (!(devpriv->ai_neverending))
> -                       if (devpriv->ai_act_scan >= devpriv->ai_scans) {        /* all data sampled */
> +                                                       /* all data sampled */
> +                       if (devpriv->ai_act_scan >= devpriv->ai_scans) {
>                                 pcl812_ai_cancel(dev, s);
>                                 s->async->events |= COMEDI_CB_EOA;
>                         }
> @@ -1030,14 +1056,16 @@ static void transfer_from_dma_buf(struct
> comedi_device *dev,
> 
>         s->async->events = 0;
>         for (i = len; i; i--) {
> -               comedi_buf_put(s->async, ptr[bufptr++]);        /*  get one sample */
> +                                                       /*  get one sample */
> +               comedi_buf_put(s->async, ptr[bufptr++]);
> 
>                 s->async->cur_chan++;
>                 if (s->async->cur_chan >= devpriv->ai_n_chan) {
>                         s->async->cur_chan = 0;
>                         devpriv->ai_act_scan++;
>                         if (!devpriv->ai_neverending)
> -                               if (devpriv->ai_act_scan >= devpriv->ai_scans) {        /* all data sampled */
> +                                                       /* all data sampled */
> +                               if (devpriv->ai_act_scan >= devpriv->ai_scans) {
>                                         pcl812_ai_cancel(dev, s);
>                                         s->async->events |= COMEDI_CB_EOA;
>                                         break;
> @@ -1060,7 +1088,7 @@ static irqreturn_t interrupt_pcl812_ai_dma(int
> irq, void *d)
>         short *ptr;
> 
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: BGN: interrupt_pcl812_ai_dma(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: BGN: interrupt_pcl812_ai_dma(...)\n");
>  #endif
>         ptr = (short *)devpriv->dmabuf[devpriv->next_dma_buf];
>         len = (devpriv->dmabytestomove[devpriv->next_dma_buf] >> 1) -
> @@ -1095,7 +1123,7 @@ static irqreturn_t interrupt_pcl812_ai_dma(int
> irq, void *d)
>         transfer_from_dma_buf(dev, s, ptr, bufptr, len);
> 
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: END: interrupt_pcl812_ai_dma(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: END: interrupt_pcl812_ai_dma(...)\n");
>  #endif
>         return IRQ_HANDLED;
>  }
> @@ -1111,11 +1139,10 @@ static irqreturn_t interrupt_pcl812(int irq, void *d)
>                 comedi_error(dev, "spurious interrupt");
>                 return IRQ_HANDLED;
>         }
> -       if (devpriv->ai_dma) {
> +       if (devpriv->ai_dma)
>                 return interrupt_pcl812_ai_dma(irq, d);
> -       } else {
> +       else
>                 return interrupt_pcl812_ai_int(irq, d);
> -       };
>  }
> 
>  /*
> @@ -1132,7 +1159,8 @@ static int pcl812_ai_poll(struct comedi_device
> *dev, struct comedi_subdevice *s)
>         spin_lock_irqsave(&dev->spinlock, flags);
> 
>         for (i = 0; i < 10; i++) {
> -               top1 = get_dma_residue(devpriv->ai_dma);        /*  where is now DMA */
> +               /*  where is now DMA */
> +               top1 = get_dma_residue(devpriv->ai_dma);
>                 top2 = get_dma_residue(devpriv->ai_dma);
>                 if (top1 == top2)
>                         break;
> @@ -1142,8 +1170,8 @@ static int pcl812_ai_poll(struct comedi_device
> *dev, struct comedi_subdevice *s)
>                 spin_unlock_irqrestore(&dev->spinlock, flags);
>                 return 0;
>         }
> -
> -       top1 = devpriv->dmabytestomove[1 - devpriv->next_dma_buf] - top1;       /*
>  where is now DMA in buffer */
> +       /*  where is now DMA in buffer */
> +       top1 = devpriv->dmabytestomove[1 - devpriv->next_dma_buf] - top1;
>         top1 >>= 1;             /*  sample position */
>         top2 = top1 - devpriv->ai_poll_ptr;
>         if (top2 < 1) {         /*  no new samples */
> @@ -1171,7 +1199,9 @@ static void setup_range_channel(struct comedi_device *dev,
>                                 unsigned int rangechan, char wait)
>  {
>         unsigned char chan_reg = CR_CHAN(rangechan);    /*  normal board */
> -       unsigned char gain_reg = CR_RANGE(rangechan) +
> devpriv->range_correction;      /*  gain index */
> +                                                       /*  gain index */
> +       unsigned char gain_reg = CR_RANGE(rangechan) +
> +                                devpriv->range_correction;
> 
>         if ((chan_reg == devpriv->old_chan_reg)
>             && (gain_reg == devpriv->old_gain_reg))
> @@ -1184,20 +1214,25 @@ static void setup_range_channel(struct
> comedi_device *dev,
>                 if (devpriv->use_diff) {
>                         chan_reg = chan_reg | 0x30;     /*  DIFF inputs */
>                 } else {
> -                       if (chan_reg & 0x80) {
> -                               chan_reg = chan_reg | 0x20;     /*  SE inputs 8-15 */
> -                       } else {
> -                               chan_reg = chan_reg | 0x10;     /*  SE inputs 0-7 */
> -                       }
> +                       if (chan_reg & 0x80)
> +                                                       /*  SE inputs 8-15 */
> +                               chan_reg = chan_reg | 0x20;
> +                       else
> +                                                       /*  SE inputs 0-7 */
> +                               chan_reg = chan_reg | 0x10;
>                 }
>         }
> 
>         outb(chan_reg, dev->iobase + PCL812_MUX);       /* select channel */
>         outb(gain_reg, dev->iobase + PCL812_GAIN);      /* select gain */
> 
> -       if (wait) {
> -               udelay(devpriv->max_812_ai_mode0_rangewait);    /*  XXX this depends
> on selected range and can be very long for some high gain ranges! */
> -       }
> +
> +       if (wait)
> +               /*
> +                * XXX this depends on selected range and can be very long for
> +                * some high gain ranges!
> +                */
> +               udelay(devpriv->max_812_ai_mode0_rangewait);
>  }
> 
>  /*
> @@ -1207,8 +1242,8 @@ static void start_pacer(struct comedi_device
> *dev, int mode,
>                         unsigned int divisor1, unsigned int divisor2)
>  {
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: BGN: start_pacer(%d,%u,%u)\n", mode, divisor1,
> -              divisor2);
> +       printk(KERN_DEBUG "pcl812 EDBG: BGN: start_pacer(%d,%u,%u)\n", mode,
> +              divisor1, divisor2);
>  #endif
>         outb(0xb4, dev->iobase + PCL812_CTRCTL);
>         outb(0x74, dev->iobase + PCL812_CTRCTL);
> @@ -1221,7 +1256,7 @@ static void start_pacer(struct comedi_device
> *dev, int mode,
>                 outb((divisor1 >> 8) & 0xff, dev->iobase + PCL812_CTR1);
>         }
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: END: start_pacer(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: END: start_pacer(...)\n");
>  #endif
>  }
> 
> @@ -1252,16 +1287,17 @@ static int pcl812_ai_cancel(struct comedi_device *dev,
>                             struct comedi_subdevice *s)
>  {
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: BGN: pcl812_ai_cancel(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: BGN: pcl812_ai_cancel(...)\n");
>  #endif
>         if (devpriv->ai_dma)
>                 disable_dma(devpriv->dma);
>         outb(0, dev->iobase + PCL812_CLRINT);   /* clear INT request */
> -       outb(devpriv->mode_reg_int | 0, dev->iobase + PCL812_MODE);     /* Stop A/D */
> +                                                       /* Stop A/D */
> +       outb(devpriv->mode_reg_int | 0, dev->iobase + PCL812_MODE);
>         start_pacer(dev, -1, 0, 0);     /*  stop 8254 */
>         outb(0, dev->iobase + PCL812_CLRINT);   /* clear INT request */
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: END: pcl812_ai_cancel(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: END: pcl812_ai_cancel(...)\n");
>  #endif
>         return 0;
>  }
> @@ -1272,7 +1308,7 @@ static int pcl812_ai_cancel(struct comedi_device *dev,
>  static void pcl812_reset(struct comedi_device *dev)
>  {
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: BGN: pcl812_reset(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: BGN: pcl812_reset(...)\n");
>  #endif
>         outb(0, dev->iobase + PCL812_MUX);
>         outb(0 + devpriv->range_correction, dev->iobase + PCL812_GAIN);
> @@ -1304,7 +1340,7 @@ static void pcl812_reset(struct comedi_device *dev)
>         }
>         udelay(5);
>  #ifdef PCL812_EXTDEBUG
> -       printk("pcl812 EDBG: END: pcl812_reset(...)\n");
> +       printk(KERN_DEBUG "pcl812 EDBG: END: pcl812_reset(...)\n");
>  #endif
>  }
> 
> @@ -1322,8 +1358,8 @@ static int pcl812_attach(struct comedi_device
> *dev, struct comedi_devconfig *it)
>         int n_subdevices;
> 
>         iobase = it->options[0];
> -       printk("comedi%d: pcl812:  board=%s, ioport=0x%03lx", dev->minor,
> -              this_board->name, iobase);
> +       printk(KERN_INFO "comedi%d: pcl812:  board=%s, ioport=0x%03lx",
> +              dev->minor, this_board->name, iobase);
> 
>         if (!request_region(iobase, this_board->io_range, "pcl812")) {
>                 printk("I/O port conflict\n");
> @@ -1345,18 +1381,18 @@ static int pcl812_attach(struct comedi_device
> *dev, struct comedi_devconfig *it)
>                 if (irq) {      /* we want to use IRQ */
>                         if (((1 << irq) & this_board->IRQbits) == 0) {
>                                 printk
> -                                   (", IRQ %u is out of allowed range, DISABLING IT",
> -                                    irq);
> +                                   (", IRQ %u is out of allowed range, "
> +                                    "DISABLING IT", irq);
>                                 irq = 0;        /* Bad IRQ */
>                         } else {
>                                 if (request_irq
>                                     (irq, interrupt_pcl812, 0, "pcl812", dev)) {
>                                         printk
> -                                           (", unable to allocate IRQ %u, DISABLING IT",
> -                                            irq);
> +                                           (", unable to allocate IRQ %u, "
> +                                            "DISABLING IT", irq);
>                                         irq = 0;        /* Can't use IRQ */
>                                 } else {
> -                                       printk(", irq=%u", irq);
> +                                       printk(KERN_INFO ", irq=%u", irq);
>                                 }
>                         }
>                 }
> @@ -1376,16 +1412,20 @@ static int pcl812_attach(struct comedi_device
> *dev, struct comedi_devconfig *it)
>                 }
>                 ret = request_dma(dma, "pcl812");
>                 if (ret) {
> -                       printk(", unable to allocate DMA %u, FAIL!\n", dma);
> +                       printk(KERN_ERR ", unable to allocate DMA %u, FAIL!\n",
> +                              dma);
>                         return -EBUSY;  /* DMA isn't free */
>                 }
>                 devpriv->dma = dma;
> -               printk(", dma=%u", dma);
> +               printk(KERN_INFO ", dma=%u", dma);
>                 pages = 1;      /* we want 8KB */
>                 devpriv->dmabuf[0] = __get_dma_pages(GFP_KERNEL, pages);
>                 if (!devpriv->dmabuf[0]) {
>                         printk(", unable to allocate DMA buffer, FAIL!\n");
> -                       /* maybe experiment with try_to_free_pages() will help .... */
> +                       /*
> +                        * maybe experiment with try_to_free_pages()
> +                        * will help ....
> +                        */
>                         free_resources(dev);
>                         return -EBUSY;  /* no buffer :-( */
>                 }
> @@ -1394,7 +1434,7 @@ static int pcl812_attach(struct comedi_device
> *dev, struct comedi_devconfig *it)
>                 devpriv->hwdmasize[0] = PAGE_SIZE * (1 << pages);
>                 devpriv->dmabuf[1] = __get_dma_pages(GFP_KERNEL, pages);
>                 if (!devpriv->dmabuf[1]) {
> -                       printk(", unable to allocate DMA buffer, FAIL!\n");
> +                       printk(KERN_ERR ", unable to allocate DMA buffer, FAIL!\n");
>                         free_resources(dev);
>                         return -EBUSY;
>                 }
> @@ -1457,11 +1497,11 @@ no_dma:
>                 s->maxdata = this_board->ai_maxdata;
>                 s->len_chanlist = MAX_CHANLIST_LEN;
>                 s->range_table = this_board->rangelist_ai;
> -               if (this_board->board_type == boardACL8216) {
> +               if (this_board->board_type == boardACL8216)
>                         s->insn_read = acl8216_ai_insn_read;
> -               } else {
> +               else
>                         s->insn_read = pcl812_ai_insn_read;
> -               }
> +
>                 devpriv->use_MPC = this_board->haveMPC508;
>                 s->cancel = pcl812_ai_cancel;
>                 if (dev->irq) {
> @@ -1500,8 +1540,8 @@ no_dma:
>                                 s->range_table = &range_bipolar10;
>                                 break;
>                                 printk
> -                                   (", incorrect range number %d, changing to 0 (+/-10V)",
> -                                    it->options[4]);
> +                                   (", incorrect range number %d, changing "
> +                                    "to 0 (+/-10V)", it->options[4]);
>                                 break;
>                         }
>                         break;
> @@ -1530,8 +1570,8 @@ no_dma:
>                                 s->range_table = &range_iso813_1_ai;
>                                 break;
>                                 printk
> -                                   (", incorrect range number %d, changing to 0 ",
> -                                    it->options[1]);
> +                                   (", incorrect range number %d, "
> +                                    "changing to 0 ", it->options[1]);
>                                 break;
>                         }
>                         break;
> @@ -1555,8 +1595,8 @@ no_dma:
>                                 s->range_table = &range_acl8113_1_ai;
>                                 break;
>                                 printk
> -                                   (", incorrect range number %d, changing to 0 ",
> -                                    it->options[1]);
> +                                   (", incorrect range number %d, "
> +                                    "changing to 0 ", it->options[1]);
>                                 break;
>                         }
>                         break;
> @@ -1627,7 +1667,8 @@ no_dma:
>         case boardACL8112:
>                 devpriv->max_812_ai_mode0_rangewait = 1;
>                 if (it->options[3] > 0)
> -                       devpriv->use_ext_trg = 1;       /*  we use external trigger */
> +                                               /*  we use external trigger */
> +                       devpriv->use_ext_trg = 1;
>         case boardA821:
>                 devpriv->max_812_ai_mode0_rangewait = 1;
>                 devpriv->mode_reg_int = (irq << 4) & 0xf0;
> @@ -1636,11 +1677,12 @@ no_dma:
>         case boardPCL813:
>         case boardISO813:
>         case boardACL8113:
> -               devpriv->max_812_ai_mode0_rangewait = 5;        /* maybe there must by
> greatest timeout */
> +               /* maybe there must by greatest timeout */
> +               devpriv->max_812_ai_mode0_rangewait = 5;
>                 break;
>         }
> 
> -       printk("\n");
> +       printk(KERN_INFO "\n");
>         devpriv->valid = 1;
> 
>         pcl812_reset(dev);
> @@ -1655,7 +1697,7 @@ static int pcl812_detach(struct comedi_device *dev)
>  {
> 
>  #ifdef PCL812_EXTDEBUG
> -       printk("comedi%d: pcl812: remove\n", dev->minor);
> +       printk(KERN_DEBUG "comedi%d: pcl812: remove\n", dev->minor);
>  #endif
>         free_resources(dev);
>         return 0;
> --
> 1.5.4.3


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
