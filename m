Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab2HPLCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:02:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58910 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab2HPLCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:02:49 -0400
MIME-Version: 1.0
In-Reply-To: <1344968568-4613-1-git-send-email-morbidrsa@googlemail.com>
References: <1344968568-4613-1-git-send-email-morbidrsa@googlemail.com>
Date: Thu, 16 Aug 2012 12:02:47 +0100
Message-ID: <CAJSP0QV9wsC_Q8swMPaGAFXnF3X-B_Ds9B06Vh+wgju=ck3rsw@mail.gmail.com>
Subject: Re: [PATCH] staging: line6: variax.c: Eliminated remaining strict_stroul()s
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@linuxfoundation.org, grabner@icg.tugraz.at,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 7:22 PM, Johannes Thumshirn
<morbidrsa@googlemail.com> wrote:
> Eliminated remaining calls to strict_stroul() and replaced them with
> strict_kstrtou8().
>
> Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
> ---
>  drivers/staging/line6/variax.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Commit description is wrong:
s/strict_kstrtou8/kstrtou8/

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
