Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab3AIUMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:12:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37024 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab3AIUMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:12:18 -0500
Message-ID: <50EDCF14.4080101@oracle.com>
Date: Wed, 09 Jan 2013 14:12:04 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
CC: Lijo Antony <lijo.kernel@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
References: <20130108223611.GA19672@kroah.com> <20130109003824.GA21075@kroah.com> <CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com> <20130109042533.GA9164@kroah.com> <CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com> <50ED1C12.2090608@gmail.com> <50EDC8A1.30307@oracle.com>
In-Reply-To: <50EDC8A1.30307@oracle.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:44 PM, Dave Kleikamp wrote:
> 
> I can easily reproduce it running glxgears on 3.8-rc1 or 3.8-rc2.
> 
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Core
> Processor Integrated Graphics Controller [8086:0046] (rev 02)
> 
> Thinkpad T410
> 
> Shaggy

Daniel's patch:

drm/i915: Revert shrinker changes from "Track unbound pages"

fixes the problem for me.

Thanks,
Shaggy
