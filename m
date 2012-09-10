Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2IJPDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:03:39 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48465 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2IJPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:03:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5CcUZ8NKM6uHkBB1Yo9MjeoBq9NzpOYwT1squM4TOgV7g@mail.gmail.com>
References: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
 <1343843371-14143-5-git-send-email-matt@genesi-usa.com> <CAOMZO5CcUZ8NKM6uHkBB1Yo9MjeoBq9NzpOYwT1squM4TOgV7g@mail.gmail.com>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 10 Sep 2012 10:03:15 -0500
Message-ID: <CAKGA1bnvu5WZMPc7Lv7ERDpaB=rz+bRHXg1ORiiwB3vWSK8dRQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] efikamx: remove Efika MX-specific CHRGVBUS hack from
 the USB driver
To: Fabio Estevam <festevam@gmail.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 9, 2012 at 10:00 PM, Fabio Estevam <festevam@gmail.com> wrote:
> On Wed, Aug 1, 2012 at 2:49 PM, Matt Sealey <matt@genesi-usa.com> wrote:
>> Since we're removing Efika MX support from the tree (for now), remove
>> the hack present in the USB host driver since it will never run and
>> isn't useful on any other systems.
>>
>> Signed-off-by: Matt Sealey <matt@genesi-usa.com>
>
> You should Cc linux-usb list and the USB maintainer on this one.

Good call, I actually thought I did that (git send-email is not my
best friend this month).

Luckily though with the board removal patches in Shawn's tree going up
at some point, this code can't be compiled anyway so this patch not
making it in will not ruin anyone's day. I'll resubmit it in the near
future but I'm not considering it top priority because of the
abovementioned reason.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
