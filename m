Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1C2GWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:22:24 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:43802 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733Ab1C2GWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:22:23 -0400
From: Par-Gunnar HJALMDAHL <par-gunnar.p.hjalmdahl@stericsson.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Date: Tue, 29 Mar 2011 08:20:30 +0200
Subject: RE: [PATCH v2 2/2] mach-ux500: Add CG2900 devices
Thread-Topic: [PATCH v2 2/2] mach-ux500: Add CG2900 devices
Thread-Index: AcvtVg7hahCAByAaS0CTHajNwQDFPwAgv1cQ
Message-ID: <AFCDDB4A3EA003429EEF1E7B211FDBBA3377B51C79@EXDCVYMBSTM005.EQ1STM.local>
References: <1301302992-10671-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <AANLkTimhcFNDdq0FCP2rVdDJ5V_YP+E82+80OavsuAS=@mail.gmail.com>
In-Reply-To: <AANLkTimhcFNDdq0FCP2rVdDJ5V_YP+E82+80OavsuAS=@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was asked to break out the CG2900 specific stuff from mach-ux500
folder and put it into the staging folder.
So the function exist in the new file
drivers/staging/cg2900/board-mop500-cg2900.c
(As you point out the file and the function did not exist in
the previous patch).

/P-G

> -----Original Message-----
> From: Vitaly Wool [mailto:vitalywool@gmail.com]
> Sent: den 28 mars 2011 16:40
> To: Par-Gunnar HJALMDAHL
> Cc: Greg Kroah-Hartman; devel@driverdev.osuosl.org; Linus Walleij;
> linux-kernel@vger.kernel.org; linux-bluetooth@vger.kernel.org; Pavan
> Savoy; Alan Cox; Arnd Bergmann; Marcel Holtmann; Lukasz Rymanowski;
> Linus WALLEIJ; Par-Gunnar Hjalmdahl; Lee Jones; Mathieu Poirier
> Subject: Re: [PATCH v2 2/2] mach-ux500: Add CG2900 devices
> 
> On Mon, Mar 28, 2011 at 11:03 AM, Par-Gunnar Hjalmdahl
> <par-gunnar.p.hjalmdahl@stericsson.com> wrote:
> >
> > +/* Function located in drivers/staging/cg2900 */
> > +extern void cg2900_init_board(void);
> > +
> 
> I'm confused. Where in the drivers/staging is this function? Couldn't
> find it in the previous patch.
> 
> ~Vitaly
