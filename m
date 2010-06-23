Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0FWOk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 10:40:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50715 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab0FWOkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 10:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ag5S09BgC6UstpwG5ZtQpoEOfrIEFkYj/JBc5yGFdOA1QNuYX1X9SY5qUuSaQWqGVz
         ozq+4KCuvzQwXs7rrlhuOwBSxBMOCgNtV9Iz74jDrqd6a9o6TB4RTdPCYzo4TdaBMtlr
         pewpFDF4lLEygkn1IVvybMQL3oXolc7ecVf1Q=
Message-ID: <4C221D03.9050006@gmail.com>
Date: Wed, 23 Jun 2010 07:41:07 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
References: <AANLkTilf41JrFwN1veRDifNA78S2LQ6SO0g3YLOONd2W@mail.gmail.com> <20100623141622.GC15205@tuxdriver.com>
In-Reply-To: <20100623141622.GC15205@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 07:16 AM, John W. Linville wrote:
> On Tue, Jun 22, 2010 at 04:16:53PM -0700, Justin Mattock wrote:
>> I remember ipsec was able to work cleanly on my machines probably
>> about 4/6 months ago
>> now I get this:
>
> <snip>
>
> Perhaps netdev would be a more appropriate list than linux-wireless
> for this?
>
> John

alright added the cc's..
almost done bisecting..hopefully this points to
the right area..(if not I'll re-bisect until I get this).

as for the troubled machines I've a macbookpro2,2(no proprietary
stuff) and an imac9,1 with broadcom-sta(blah) both
seem to hit this right when the ipsec transaction starts
with ssh, vncviewer..(last good kernel I have is
2.6.33-rc5-01007-ge9449d8).

Justin P. Mattock
