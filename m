Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab2CLOwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:52:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab2CLOwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:52:44 -0400
Date: Mon, 12 Mar 2012 15:52:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jason Gerecke <killertofu@gmail.com>
Cc: Przemo Firszt <przemo@firszt.eu>, pinglinux@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] HID: wacom: Reset stylus buttons - Intuos4 WL
In-Reply-To: <CANRwn3T0osghgP4i_e0xK8FkvKv1gXMwnumggv0pkxrDqPqKDQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1203121552300.18356@pobox.suse.cz>
References: <1331299252-23699-1-git-send-email-przemo@firszt.eu> <CANRwn3T0osghgP4i_e0xK8FkvKv1gXMwnumggv0pkxrDqPqKDQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Jason Gerecke wrote:

> > Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> > ---
> >  drivers/hid/hid-wacom.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> > index 2a440a6..5c25036 100644
> > --- a/drivers/hid/hid-wacom.c
> > +++ b/drivers/hid/hid-wacom.c
> > @@ -352,6 +352,8 @@ static void wacom_i4_parse_pen_report(struct wacom_data *wdata,
> >        case 0x80: /* Out of proximity report */
> >                input_report_key(input, BTN_TOUCH, 0);
> >                input_report_abs(input, ABS_PRESSURE, 0);
> > +               input_report_key(input, BTN_STYLUS, 0);
> > +               input_report_key(input, BTN_STYLUS2, 0);
> >                input_report_key(input, wdata->tool, 0);
> >                input_report_abs(input, ABS_MISC, 0);
> >                input_event(input, EV_MSC, MSC_SERIAL, wdata->serial);
> > --
> > 1.7.6.4
> 
> Reviewed-by: Jason Gerecke <killertofu@gmail.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
