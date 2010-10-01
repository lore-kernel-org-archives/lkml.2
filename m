Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0JAJVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 05:21:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47883 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0JAJVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <1285922192.13411.53.camel@marc>
References: <4CA391B3.1030806@wol.de> <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
 <1285843077.748.32.camel@marc> <AANLkTi=d+5uDVK9RHguSmwFhKLVUPXvzo=G3s=NKKDW3@mail.gmail.com>
 <20100930122928.19e5ee84@lxorguk.ukuu.org.uk> <1285851024.748.97.camel@marc>
 <AANLkTimRa9VsOgSkcdrg=41pskEbMhNL4D9SXeV3dztG@mail.gmail.com> <1285922192.13411.53.camel@marc>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 Oct 2010 11:20:49 +0200
Message-ID: <AANLkTim2jkC-c+JLB3jV4mfaO_+Q0dNNe=Uc6nOJi-yd@mail.gmail.com>
Subject: Re: [PATCH] Fix capi devicenames
To: "Marc - A. Dahlhaus" <mad@wol.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        isdn@linux-pingi.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 10:36, Marc - A. Dahlhaus <mad@wol.de> wrote:
> Am Donnerstag, den 30.09.2010, 21:20 +0200 schrieb Kay Sievers:

> for the capi tty, if not mistaken, it looks like i need to add a
> dev->devnode = 'capi/';
> line but i have no clue what it needs to change the capi_class.
> Looks like a larger rework of the code in capi.c to me.

You should be able to do just do what we did for all other stuff that
lives in its own /dev sub-directory:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=aa5ed63e96656bb246a9439e06c7b67d455a5aa1

Kay
