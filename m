Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1KMRii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 12:38:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50816 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1KMRih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 12:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <CADDKRnD6oL-WAdDowLoC9e8nqNdg9_coCaS49rfTY2PxCCwZvw@mail.gmail.com>
References: <CADDKRnCq_h5YPcSCoOnW3q+8Q8r5UV3Wj6oJ4UE5UV+Keb1M1Q@mail.gmail.com>
	<CADDKRnD6oL-WAdDowLoC9e8nqNdg9_coCaS49rfTY2PxCCwZvw@mail.gmail.com>
Date: Sun, 13 Nov 2011 17:38:37 +0000
Message-ID: <CAPM=9twNXMbexaUg2MVC_ZCZczM57U6NsRMZVs8wPFv6f0KUSQ@mail.gmail.com>
Subject: Re: [v32-rc1+] radeon kernel crash
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 2:20 PM, Jörg Otte <jrg.otte@googlemail.com> wrote:
> The following commit causes the kernel to crash:
> commit 8f3f1c9a22a6420e28c2d3eff59b832893bc8efc
>  "drm/radeon/kms/pm: switch to dynamically allocating clock mode array"
>
> It happens at a very early stage. So I have no logs, no displays, no
> nothing.
> Reverting 8f3f1c9a22a6420e28c2d3eff59b832893bc8efc fixes the problem.
> HW is a Thinkpad T43.

Fix is in my drm-fixes tree, will send to Linus now.

Dave.
