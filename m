Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1LGBpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:45:08 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35914 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1LGBpD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:45:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAJL_dMvbL0LBrJ4irP3vd_PA458i0YefWpmvMgphuT+TnF2O5Q@mail.gmail.com>
References: <CAPLs8y9omncDbLE_KNoKOLLbfwHjWYUJX_i7cC4bLiJsyPbtZQ@mail.gmail.com>
 <CAJL_dMtgP+BqFn3aGVBbGDJ+kMyGiEC_NmDURzh4mU=Jo=qZVA@mail.gmail.com>
 <CAPLs8y8vhioqc3CPrD7ugmVkR2DjKWNm8+T5j9QQnrxi=BgvdA@mail.gmail.com>
 <CAJL_dMtvgnZHH0uLE3j7Mg2Xqwt2rd90Uy0pUxm6muPmjFbkQg@mail.gmail.com> <CAJL_dMvbL0LBrJ4irP3vd_PA458i0YefWpmvMgphuT+TnF2O5Q@mail.gmail.com>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Wed, 7 Dec 2011 03:44:29 +0200
Message-ID: <CAPLs8y-sc7CZw2Yb11A-jTEMmTYva==XHgCqK1UmWN6_HX0rfA@mail.gmail.com>
Subject: Re: v6: faster tree-based sysctl implementation
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 2:08 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> You can ask Stephen Rothwell to include your tree in next.
> git://github.com/luciang/linux-2.6-new-sysctl.git  v6-new-sysctl-alg


Thank you Anca, but I don't want to pollute Stephen's linux-next tree ATM.
I'd wait until a maintainer chimes in and agrees that this approach is sound.

-- 
 .
..: Lucian
