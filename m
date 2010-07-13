Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0GMJgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:36:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44163 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab0GMJgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NYFi+IcauQM+1GwqkKYhtenL+MEfDDQAfKZZPSttJWFb9dSxlGun78bcUVUOBqIYYv
         gQZuzerYX6tvgCvxilxyTqXiAfpXYi7YQi6VaHjcxxnRD1TTc9d9UmgS9ENFApIpgsqJ
         ropamCZHiR5ZSEi4ubHD0Z5hQ6/2+jOkkhV34=
MIME-Version: 1.0
In-Reply-To: <1279012915.28403.235.camel@thorin>
References: <1278969997-24254-1-git-send-email-roel.vannyen@gmail.com>
	<1279012915.28403.235.camel@thorin>
Date: Tue, 13 Jul 2010 11:36:12 +0200
Message-ID: <AANLkTimLwZbKilIkcd1DAFnRtn0Ujhkq6hh8C8bIWzle@mail.gmail.com>
Subject: Re: [PATCH] Staging: vt6656: Change the define FALSE and TRUE to the 
	lower case variant.
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/13 Bernd Petrovitsch <bernd@petrovitsch.priv.at>
>
> Hi!
>
> On Mon, 2010-07-12 at 23:26 +0200, Roel Van Nyen wrote:
> [...]
> > @@ -178,7 +178,7 @@ vMgrDecodeBeacon(
> >              break;
> >          case WLAN_EID_RSN_WPA:
> >              if (pFrame->pRSNWPA == NULL) {
> > -                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
> > +                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == true)
> >                      pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
> >              }
> >              break;
>
> Am I the only one who thinks that this should better be
> ----  snip  ----
> @@ -178,7 +178,7 @@ vMgrDecodeBeacon(
>             break;
>         case WLAN_EID_RSN_WPA:
>             if (pFrame->pRSNWPA == NULL) {
> -                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem) == TRUE)
> +                if (WPAb_Is_RSN((PWLAN_IE_RSN_EXT)pItem))
>                     pFrame->pRSNWPA = (PWLAN_IE_RSN_EXT)pItem;
>             }
>             break;
> ----  snip  ----
> - if only for readability and understandability?
>
>        Bernd
> --
> Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
>                     LUGA : http://www.luga.at
>

Hi!

I think from a readability and understandability standpoint == true is
very clear, anyone who reads it will explicitly understand the
meaning.
The goal of my patch is to remove the defines from the ttype.h so that
at some time ttype.h can be removed.

Any more pros or cons for the == true ?
Roel
