Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab1CaSH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:07:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37401 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab1CaSH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=FkjEgfpWlCPFF/nxvqur02M99ka7Lu8qp2C0hyc4OH8OE6GHCuxZZNYo8Cp84KV7za
         ZF64Dc2rfIh+QEZ35CDPoe0ie8qutzrzOdexPk5GzS5g5eOqDwuUnRXH6CDqf9LZRIjS
         xC6OQRMsia0tHeSQzBnx7D7dnHkD9weWtSPQI=
Date: Thu, 31 Mar 2011 11:07:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        pingc@wacom.com
Subject: Re: [PATCH] add support for Lenovo tablet ID (0xE6)
Message-ID: <20110331180632.GB414@core.coreip.homeip.net>
References: <1301592052-4064-1-git-send-email-manoj.iyer@canonical.com>
 <1301592052-4064-2-git-send-email-manoj.iyer@canonical.com>
 <20110331174334.GA414@core.coreip.homeip.net>
 <AANLkTi=a1eZS2fjxKYzf1RsE=6n9wZwUTPs8v84zb6p_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=a1eZS2fjxKYzf1RsE=6n9wZwUTPs8v84zb6p_@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:58:57PM -0500, Chris Bagwell wrote:
> On Thu, Mar 31, 2011 at 12:43 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Thu, Mar 31, 2011 at 12:20:52PM -0500, Manoj Iyer wrote:
> >> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> >> ---
> >>  drivers/input/tablet/wacom_wac.c |    3 +++
> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
> >> index 5597637..f751224 100644
> >> --- a/drivers/input/tablet/wacom_wac.c
> >> +++ b/drivers/input/tablet/wacom_wac.c
> >> @@ -1364,6 +1364,8 @@ static const struct wacom_features wacom_features_0xE2 =
> >>       { "Wacom ISDv4 E2",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
> >>  static const struct wacom_features wacom_features_0xE3 =
> >>       { "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
> >> +static const struct wacom_features wacom_features_0xE6 =
> >> +     { "ISD-V4",               WACOM_PKGLEN_TPC2FG,    27760, 15694,  255,  0, TABLETPC2FG };
> >
> > Manoj, shouldn't we call it "Wacom ISDv4 E6" to be consistent?
> 
> I think its best to rename to be consistent with others in series.
> 
> >
> > Ping, is resolution the same as with other "ISDv4"s?
> 
> My guess is yes.
> 
> Note: There is a patch from Ping that you recently accepted but I do
> not see on a branch yet (maybe I'm looking in wrong place).

If we are talking about the same thing it shoudl be in my 'for-linus'
branch.

Thanks.

-- 
Dmitry
