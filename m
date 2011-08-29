Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1H2Hz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:55:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:7087 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab1H2Hzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:55:51 -0400
Date: Mon, 29 Aug 2011 09:55:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans Berglund <hb@spacetec.no>, Jonas Bonn <jonas@southpole.se>,
        Arnd Bergmann <arnd@arndb.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: I2C_ELEKTOR should depend on HAS_IOPORT
Message-ID: <20110829095530.789ec9ea@endymion.delvare>
In-Reply-To: <CAMuHMdVX_p4Q1E+-Q1HOjUO-Zhbsv_uji2qqGZipii=qY0hHWw@mail.gmail.com>
References: <1312802446-19154-1-git-send-email-geert@linux-m68k.org>
	<20110816195033.014f302b@endymion.delvare>
	<CAMuHMdUk_xTwGbhG0MHkS-8rkF76b1fg193pPcs+9MVyB-qHQw@mail.gmail.com>
	<20110817113910.47dc819f@endymion.delvare>
	<CAMuHMdVX_p4Q1E+-Q1HOjUO-Zhbsv_uji2qqGZipii=qY0hHWw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Mon, 29 Aug 2011 09:48:17 +0200, Geert Uytterhoeven wrote:
> On Wed, Aug 17, 2011 at 11:39, Jean Delvare <khali@linux-fr.org> wrote:
> > OK, fair enough. Patch applied, thanks.
> 
> Any chance it will finds its way in 3.1, since it's still breaking
> m68k allmodconfig builds.

This is the plan, yes. It should happen by the end of the week.

-- 
Jean Delvare
