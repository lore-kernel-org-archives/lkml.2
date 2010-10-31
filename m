Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0JaHmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 03:42:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37148 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0JaHmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 03:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=bkczF98YWrvBSlleP0dqSj3+u7xXNVagajpATVjk9t2WNu1S6+P0dFiKdrMb2XgHD1
         Vrw3G+KzJh5BSTWhLQK4DOH5Jxv3njR/wofSxaxDtPlbV2TLdxXUZ86V5iCvRHKFga60
         j2hLD7SV9PjGkiYAQTv9912oJexjM1cgGMgT4=
Message-ID: <4CCD1DD8.6020604@suse.cz>
Date: Sun, 31 Oct 2010 08:42:16 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Typo in tty_driver.h?
References: <4CC9E99A.3070903@freescale.com>
In-Reply-To: <4CC9E99A.3070903@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 11:22 PM, Timur Tabi wrote:
> I believe I found a typo in a comment in tty_driver.h
> 
>  * TTY_DRIVER_DYNAMIC_DEV --- if set, the individual tty devices need
>  *	to be registered with a call to tty_register_driver() when the
>  *	device is found in the system and unregistered with a call to
>  *	tty_unregister_device() so the devices will be show up
>  *	properly in sysfs.  If not set, driver->num entries will be
>  *	created by the tty core in sysfs when tty_register_driver() is
>  *	called.  This is to be used by drivers that have tty devices
>  *	that can appear and disappear while the main tty driver is
>  *	registered with the tty core.
> 
> On line 2, I think it should say "tty_register_device()" instead of
> "tty_register_driver()".

Yes, you're correct. Care to bake a patch?

regards,
-- 
js
suse labs
