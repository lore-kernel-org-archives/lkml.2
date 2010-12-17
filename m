Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0LQMa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:30:28 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:33818 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410Ab0LQMa1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:30:27 -0500
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Pavan Savoy <pavan_savoy@sify.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Date: Fri, 17 Dec 2010 13:29:11 +0100
Subject: RE: [PATCH 08/11] Bluetooth: Add support for CG2900 UART
Thread-Topic: [PATCH 08/11] Bluetooth: Add support for CG2900 UART
Thread-Index: Acud4lbp53A4EoDzTmioalK3d6BwtgAAqE9Q
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA33489D2B69@EXDCVYMBSTM005.EQ1STM.local>
References: <1292585117-28584-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <AANLkTimjDCF4V9wGszVcuDYqZ8Qq0CYhCzxnxEKcibxN@mail.gmail.com>
In-Reply-To: <AANLkTimjDCF4V9wGszVcuDYqZ8Qq0CYhCzxnxEKcibxN@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: EtSH Fj84 K8rG dpFU fqGp f7hE mPzQ z/PQ AAT8Cg== ABSZnA==
 ADYshw== AFCarw== AJTg2A== AJqLGQ== AK+/QA==
 AOBn9A==;10;YQBsAGEAbgBAAGwAeABvAHIAZwB1AGsALgB1AGsAdQB1AC4AbwByAGcALgB1AGsAOwBhAHIAbgBkAEAAYQByAG4AZABiAC4AZABlADsAbABpAG4AdQB4AC0AYgBsAHUAZQB0AG8AbwB0AGgAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAHUAawBhAHMAegAuAHIAeQBtAGEAbgBvAHcAcwBrAGkAQAB0AGkAZQB0AG8ALgBjAG8AbQA7AG0AYQByAGMAZQBsAEAAaABvAGwAdABtAGEAbgBuAC4AbwByAGcAOwBwAGEAdgBhAG4AXwBzAGEAdgBvAHkAQABzAGkAZgB5AC4AYwBvAG0AOwBwAGcAaABhAHQAdwBvAHIAawBAAGcAbQBhAGkAbAAuAGMAbwBtADsAcwBhAG0AZQBvAEAAbABpAG4AdQB4AC4AaQBuAHQAZQBsAC4AYwBvAG0AOwB2AGkAdABhAGwAeQB3AG8AbwBsAEAAZwBtAGEAaQBsAC4AYwBvAG0A;Sosha1_v1;7;{01889561-BEE1-42F1-9FFC-0303E56B287C};cABhAHIALQBnAHUAbgBuAGEAcgAuAHAALgBoAGoAYQBsAG0AZABhAGgAbABAAHMAdABlAHIAaQBjAHMAcwBvAG4ALgBjAG8AbQA=;Fri,
 17 Dec 2010 12:29:11
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADAAOAAvADEAMQBdACAAQgBsAHUAZQB0AG8AbwB0AGgAOgAgAEEAZABkACAAcwB1AHAAcABvAHIAdAAgAGYAbwByACAAQwBHADIAOQAwADAAIABVAEEAUgBUAA==
x-cr-puzzleid: {01889561-BEE1-42F1-9FFC-0303E56B287C}
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vitaly,

> -----Original Message-----
> From: Vitaly Wool [mailto:vitalywool@gmail.com]
> Sent: den 17 december 2010 13:03
> To: Par-Gunnar HJALMDAHL
> Cc: Pavan Savoy; Alan Cox; Arnd Bergmann; Samuel Ortiz; Marcel
> Holtmann; linux-kernel@vger.kernel.org; linux-
> bluetooth@vger.kernel.org; Lukasz Rymanowski; Linus WALLEIJ; Par-Gunnar
> Hjalmdahl
> Subject: Re: [PATCH 08/11] Bluetooth: Add support for CG2900 UART
> 
> Hi Par,
> 
> so on the top level: this is yet another H4 implementation plus
> channel-based packet routing, right?
> 
> Could you please also elaborate
> 

Yes, the low-level basis is similar to e.g. hci_h4.c, where we register to N_HCI line discipline and then use the first byte to separate between different channels.
While hci_h4.c supports only the standardized Bluetooth H4 channels, the cg2900_uart targets also the CG2900 specific H4 channels.

> More comments on the code are inlined.
> 
> > +#define MAIN_DEV               (uart_info->dev)
> 
> What is that for?
> 

This is just a simplification when using for example dev_err(). It's just to shorten the text (not much in this case but there are other files where it looks better).
No big problem to fix if you want that.

> > + * cg2900_uart_suspend() - Called by Linux PM to put the device in a
> low power mode.
> > + * @pdev:      Pointer to platform device.
> > + * @state:     New state.
> > + *
> > + * In UART case, CG2900 driver does nothing on suspend.
> > + *
> > + * Returns:
> > + *   0 - Success.
> > + */
> > +static int cg2900_uart_suspend(struct platform_device *pdev,
> pm_message_t state)
> > +{
> > +       struct uart_info *uart_info = dev_get_drvdata(&pdev->dev);
> > +
> > +       if (uart_info->sleep_state == CHIP_POWERED_DOWN)
> > +               return 0;
> > +
> > +       if (uart_info->sleep_state != CHIP_ASLEEP)
> > +               return -EBUSY;
> > +
> > +       dev_dbg(MAIN_DEV, "New sleep_state: CHIP_SUSPENDED\n");
> > +       uart_info->sleep_state = CHIP_SUSPENDED;
> > +       return 0;
> > +}
> 
> I don't think this is safe wrt work queue. What if it gets scheduled
> when drivers are suspended?
> 
> Thanks,
>    Vitaly

I'm not 100% sure what you mean since I don't think sleep_state should ever be in CHIP_ASLEEP if we have a work ongoing or in the queue, but I will ask our low power expert to look into this.

/P-G
