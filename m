Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2LDIg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:36:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2LDIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:36:58 -0500
Date: Tue, 4 Dec 2012 09:36:55 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121204083655.GA21235@fancy-poultry.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <CAHdPZaP6HvM=UqkAjyC8MFMv9ZFTyxjx-CsMQ+8QZaxPCaW1Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHdPZaP6HvM=UqkAjyC8MFMv9ZFTyxjx-CsMQ+8QZaxPCaW1Hw@mail.gmail.com>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:ipHr/hobKxmiIHVrQ9eHKfpEUJ4maITVKTrdX1RG9JY
 KIiN9iMABvGGpjCTrG8Qil2Vku/pjn9WXfzQk3V5bJtOoNNHAs
 TC202WAeS7JtNdXWD6l1O6il9dmVfMGzP8DTgtyIXwu3z+dSfm
 Q+dEt40WsXXM9maitHB7dTP30aBoZGPg6jwZwj1az2SeAkWiGK
 WT7XfFhFtzv5Yf7segkX/Ffcl8Rj+YDfq2xs9nMosIV1MZd6Do
 hifxpDSpVbUDMd2JCT/1gkxhfLzUMiSyZ7O5/KPOUyXCza66t9
 I+GCh3VdULXwgbo8Vi76h/rnsPBMR6Y6L3rmR7ufLphBNwsDjc
 8Vp3kUN+NkLOcM9NKZZpbLnIEjRr49OjOLnh505V0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.12.2012, devendra.aaru wrote: 

> Add more CC's

Thanks!

This is a real showstopper for me, it occurs in every session now. 
Booting with "i915.i915_enable_rc6=0" doesn't help either..

