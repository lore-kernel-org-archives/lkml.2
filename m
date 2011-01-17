Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1AQTJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:09:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57720 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1AQTJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:09:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P3ld8D//6nf7XbbymZiipoya4gaEuM/1ji6ZyxY1BwgBDp7TXCSqenxG3iaOEejadQ
         BSamOCWj+TrajwZhMK+e9rJMgdFZ5SZ/Yn+wT1lXa0sFOH8e6jHnQp9a368gOkw2f3rw
         QE+L4NQu1rtIMEI3QY262/a31J8njpxx5UUvY=
Date: Mon, 17 Jan 2011 11:08:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] toshiba_acpi: Additional TOS1900 devices support
Message-ID: <20110117190849.GB27245@core.coreip.homeip.net>
References: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Azael,

On Mon, Jan 17, 2011 at 10:45:01AM -0700, Azael Avalos wrote:
> 
> -static const struct key_entry toshiba_acpi_keymap[] __initconst = {
> +static struct key_entry toshiba_acpi_keymap[]  = {

Why are we losing constness here?

Thanks.

-- 
Dmitry
