Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0DAHof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:44:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47286 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab0DAHo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jew67+vfWsM5cT+FoRjMIU4PNKaTdq+Tmo4B9zdhnKl0ewRJ5uIxk+Yp4iXd8GAHv9
         4tkbZG9yQW2eMGk/2mMkY5rHuSEIrOOXIJ1IEfMWIc40t0JiKg1EeUhxDDB1HnDJLJGK
         xV7enGWzQlQqeeNhTWrSiV6ASdqvo9aVAu8As=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1004010827500.26841@skynet.skynet.ie>
References: <alpine.DEB.2.00.1004010827500.26841@skynet.skynet.ie>
Date: Thu, 1 Apr 2010 09:44:26 +0200
Message-ID: <g2ob170af451004010044k1d9b8ae2n61f444f1b162abb4@mail.gmail.com>
Subject: Re: [git pull] drm tree
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 1 kwietnia 2010 09:32 użytkownik Dave Airlie <airlied@linux.ie> napisał:
> a pull from nouveau + minor drm core fixes,
>
> Lots of radeon fixes from Alex@AMD, main thing is turning off the use of
> the hw i2c engine by default again, it was causing problems for some
> people, we now have a module option. Lots of misc radeon fixes from Alex
> also, along with RV7xx HDMI audio enabling fixes. No GPU reset or
> placement patches. Hopefully this doesn't contain either an April Fools
> joke or an Easter Egg.

Hey, thanks :)

-- 
Rafał
