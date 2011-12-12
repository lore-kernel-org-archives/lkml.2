Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1LLPJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:09:13 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57970 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab1LLPJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:09:10 -0500
MIME-Version: 1.0
In-Reply-To: <1323697308-25121-1-git-send-email-dbaluta@ixiacom.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	<1323697308-25121-1-git-send-email-dbaluta@ixiacom.com>
Date: Mon, 12 Dec 2011 17:09:08 +0200
Message-ID: <CACVxJT_Gcve8ANGcvYETa5ewk1A6EQBSBT6XB=aM63xPDbhVsA@mail.gmail.com>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, marek.belisko@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11, Daniel Baluta <dbaluta@ixiacom.com> wrote:
> We can easily get kref refcount value by accesing
> kref->refcount but it is better to have a function
> for this.

You're missing a point. Refcount value as-is is not interesting.
You do GET/PUT operations and you don't care.
