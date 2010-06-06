Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0FFHtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 03:49:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35038 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0FFHt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 03:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BQqR4aNQwTsF/GCTnPNF0UljoAgIgdzWLWvHwxoypPbLBn7LbUKftKLPrpMwAwop8A
         3kA0oBX/xwYjuqryEENCBrQr5v50rNhej+oQQ7rCYAx/Xe+7qfI6GH8BcC84Ypse+DuL
         zpqmolSkw4MqKktNwuK+U0VXdPB+0w7Q18Txs=
Message-ID: <4C0B5307.1020206@gmail.com>
Date: Sun, 06 Jun 2010 01:49:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: DanVolkman <danvolkman@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.32-22-generic sata problems
References: <4C0A6326.1090100@gmail.com>
In-Reply-To: <4C0A6326.1090100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2010 08:45 AM, DanVolkman wrote:
> SYNOPSES
> ==========
> Kernel fails to boot when multiple SATA drives are connected. After a
> day of working on the problem (changing cables, sata positions,
> motherboards, CPUs, power supplies, etc.) I discovered that with only
> the boot drive connected everything worked fine.
>
> BACKGROUND
> =============
> I had a career in UNIX so it is common for me to use cpio(1), tar(1),
> dump(1), and dd(1) to replicate disks but have not been able to do so
> with two SATA disks connected using older kernels but with this new
> kernel I could not even have the second disk connected.
>
> PROBLEM APPEARED WHEN
> ======================
> An Ubuntu kernel update stopped my computer from booting. I have no
> backup computer so my description is sketchy because I was not willing
> to use a pencil and write the lengthy terse information. Boot error
> message was something like:
>
> Gave up waiting for root device. Common problems:0f106d71e58
> ...
> ALERT! /dev/disk/by-uuid/..... does not exist. Dropping to a shell!

Can you get any of the libata messages showing up on the console? You 
might need to change grub options to boot with more debug displayed 
(don't know how to do that offhand on Ubuntu).
