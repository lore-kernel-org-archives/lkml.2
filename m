Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1C1Otl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:49:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1C1Otj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:49:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH v2 2/2] mach-ux500: Add CG2900 devices
Date: Mon, 28 Mar 2011 16:49:24 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Par-Gunnar Hjalmdahl" <par-gunnar.p.hjalmdahl@stericsson.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Pavan Savoy <pavan_savoy@sify.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
References: <1301302992-10671-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com> <AANLkTimhcFNDdq0FCP2rVdDJ5V_YP+E82+80OavsuAS=@mail.gmail.com>
In-Reply-To: <AANLkTimhcFNDdq0FCP2rVdDJ5V_YP+E82+80OavsuAS=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103281649.25140.arnd@arndb.de>
X-Provags-ID: V02:K0:G0G8bOwfCL3JKKfCAktCxkl9JtF7HWRsBbrOU3zFIJE
 +GDTm4bNPMQtJba2dQoT3qI7kVt7GGCqWAfPqOLBZhU8y7CdaZ
 yCNLArmLTqPkYDrr/96g8ah9WgJ79XVrDLO/tl+f7PHo2N/0hN
 J9JdA08iXW9fMzKaGTnNSwW345W5BL7NrJc622jgRv6jAeNsvG
 jRikcWJaM2Q2iMQoyKzBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 March 2011, Vitaly Wool wrote:
> On Mon, Mar 28, 2011 at 11:03 AM, Par-Gunnar Hjalmdahl
> <par-gunnar.p.hjalmdahl@stericsson.com> wrote:
> >
> > +/* Function located in drivers/staging/cg2900 */
> > +extern void cg2900_init_board(void);
> > +
> 
> I'm confused. Where in the drivers/staging is this function? Couldn't
> find it in the previous patch.

It's in v2 of patch 2/2, in

drivers/staging/cg2900/board-mop500-cg2900.c

	Arnd
