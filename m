Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1ATHpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:45:13 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64019 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1ATHpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:45:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C2nsQfsRXx1+nWxvBcJYR7X1gcxfIyvo8dVaoPFI/nS6cOinVJLh8yAPHkTVMNfLQY
         hJ20tktGWFZTzggrkmJjTFdn2HR1sjDW8yoc9rhgdGniEWuqmp66JeO/rlDRb6kg9otH
         6Ac75mW/6rcn7EMZ/gu7mCtFpiU6MUnFJ1NOw=
Date: Wed, 19 Jan 2011 23:45:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] toshiba_acpi: Additional TOS1900 devices support
Message-ID: <20110120074503.GD30522@core.coreip.homeip.net>
References: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
 <20110117190849.GB27245@core.coreip.homeip.net>
 <AANLkTindwH2X79vZTBHU04oomxqV=RchRVEwrDEcntVX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTindwH2X79vZTBHU04oomxqV=RchRVEwrDEcntVX@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 02:05:10PM -0700, Azael Avalos wrote:
> 
> Some TOS1900 devices send keycodes via KBD, a filter was added
> along with a cleanup made by Matthew Garrett, also functions
> and registers were added for the Toshiba Software
> Configuration Interface (SCI) used by Illumination.
> Bumping its version to 0.20
> 
> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>

Input parts look good to me.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry
