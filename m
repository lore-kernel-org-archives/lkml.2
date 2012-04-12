Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761905Ab2DLCxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:53:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35412 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279Ab2DLCxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:53:34 -0400
Message-ID: <4F864399.8060105@zytor.com>
Date: Wed, 11 Apr 2012 19:53:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk> <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org> <4F80B9AC.2010103@zytor.com> <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com> <4F81D254.9090000@zytor.com> <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com> <20120412010804.GI6589@ZenIV.linux.org.uk> <CAPXgP13zqFMTsndaW3YVZEA=aKMGsG-nO+i8k9frmSAzUNyrzA@mail.gmail.com>
In-Reply-To: <CAPXgP13zqFMTsndaW3YVZEA=aKMGsG-nO+i8k9frmSAzUNyrzA@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 07:27 PM, Kay Sievers wrote:
> 
> Yeah, and? The dev_t still works from the static /dev/ like it didi 10
> years ago. All good.
> 

That *is* the legacy mode which we'd like to get rid of.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

