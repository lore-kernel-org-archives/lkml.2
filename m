Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0LJMqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 07:46:21 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:55491 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0LJMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 07:46:19 -0500
Message-ID: <4D0220DE.3030702@ru.mvista.com>
Date: Fri, 10 Dec 2010 15:45:18 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Dan Williams <dcbw@redhat.com>,
        Joe Perches <joe@perches.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial/usb_wwan: Add missing uaccess.h / fix build failure
References: <1291933655-23130-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1291933655-23130-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-12-2010 1:27, Peter Huewe wrote:

> This patch fixes a build failure[1]

    You reference will be lost when the patch is applied, as it's below the 
tearline.

> by adding the missing uaccess.h needed
> for copy_from_user and copy_to_user

> Signed-off-by: Peter Huewe<peterhuewe@gmx.de>
> ---
> KernelVersion: linux-next-20101209

> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/3607218/
> Used Config:
> s3c2410_defconfig

WBR, Sergei
