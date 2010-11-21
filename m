Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab0KUOMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:12:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63110 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab0KUOMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:12:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BaK/s+cChDZ79/dykr2tuQFHEnpZWpxIJw0jnhmsVugaWCvZj6pRd4DdmpTxSR8OL6
         VLIozSZNN5lc4JAum8w+N879ZZQoej1rTzEkeUverqt9hrhSpn85Fgg2Djxjc5lKBSQU
         vE7EITEHu9ttv54Dn/or2TWwtrvy92RbMSdjE=
Message-ID: <4CE928DD.2010309@gmail.com>
Date: Sun, 21 Nov 2010 16:12:45 +0200
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Nathan Laredo <laredo@gnu.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dave Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org,
        Alessio Igor Bogani <alessioigorbogani@gmail.com>
Subject: Re: [PATCH 0/7] BKL removal follow-up
References: <1290007619-5787-1-git-send-email-arnd@arndb.de> <20101118233439.GB5004@quack.suse.cz> <AANLkTin0Gm8Xqm-ARGmd4T+fCM4mMA0=PbDA6eSsYUOG@mail.gmail.com>
In-Reply-To: <AANLkTin0Gm8Xqm-ARGmd4T+fCM4mMA0=PbDA6eSsYUOG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2010 01:40 AM, Linus Torvalds wrote:
> On Thu, Nov 18, 2010 at 3:34 PM, Jan Kara <jack@suse.cz> wrote:
>>
>>  Just for info, UDF BKL removal patches seem to work fine but I want to
>> give them some final SMP testing on Monday before pushing them to -next.
>> I'm not sure how much people hurry with disabling the lock so if I should
>> push them ASAP or whether the next merge window is fine...
> 
> I don't think I can reasonably do it in 37, we're late enough in the
> -rc series. So UDF and really saying 'n' to BKL by default will have
> to be for the next merge window.
> 
> I hate to do it, but I'd be too nervous about it any other way.
> 
>                    Linus

Could it not default to "n" but be SELECTed by the like of UDF. Or
that too big of a Kconfig change for 37-rcX? I understand it does
not really buy us anything for distro's with allmodconfig style,
but it should help with defconfig on all the other ARCH's.

Thanks
Boaz
