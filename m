Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab2EIWId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:08:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50334 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494Ab2EIWIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <4FAAE9D9.40707@gmail.com>
References: <4FAAE6EA.3080308@gmail.com>
	<CAFLxGvzo9JNGdxGqr1nn+aQtq7aiVOqkn+bD7Xn7idvfKo-wrA@mail.gmail.com>
	<4FAAE9D9.40707@gmail.com>
Date: Thu, 10 May 2012 00:08:29 +0200
Message-ID: <CAFLxGvxAd9HFJuG_GdkzZvfSp1EBNcg1S4v6O3dNpRMKRX45Rw@mail.gmail.com>
Subject: Re: [PATCH] allow to create a minix3fs with a blocksize != 1K
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-7?Q?Vladimir_=27=F6=2Dcoder=2Fphcoder=27_Serbinenko?= 
	<phcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 12:04 AM, Vladimir 'ö-coder/phcoder'
Serbinenko <phcoder@gmail.com> wrote:
> Yes, I've already noticed this and resent it to the util-linux list.
> Do you know if linux-kernel is the right list for my other patches like
> wrong minixfs block allocation check or AFFS race condition? It seems
> they've all been ignored.

Not really.
At least send them to linux-fsdevel too.
Please read MAINTAINERS and Documentation/SubmittingPatches and
use checkpatch.pl/get_maintainer.pl.

-- 
Thanks,
//richard
