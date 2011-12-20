Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab1LTMel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 07:34:41 -0500
Received: from smtp.altlinux.org ([194.107.17.36]:45820 "EHLO
	smtp.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1LTMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 07:34:34 -0500
To: <ebiederm@xmission.com>
Subject: Re: [PATCH] sysfs: change permissions for /sys from 0755 to 0555
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 20 Dec 2011 16:34:24 +0400
From: Vitaly Kuznetsov <vitty@altlinux.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
In-Reply-To: <m162hdmgul.fsf@fess.ebiederm.org>
References: <1b3c733f0412e214042566bac2c3f3e6@hadoop.ru>
 <m162hdmgul.fsf@fess.ebiederm.org>
Message-ID: <43fec27192a0a3b8ed2bd4e3af55494d@hadoop.ru>
User-Agent: Roundcube Webmail/0.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Dec 2011 18:32:18 -0800, ebiederm@xmission.com wrote:
> Vitaly Kuznetsov <vitty@altlinux.ru> writes:
>
>> There is a misleading difference between /proc and /sys permissions, 
>> /proc is
>> 0555 and /sys is 0755. But
>> as it is impossible to create or unlink something in /sys it would 
>> be nice to
>> have same permissions.
>
> Where does this difference matter?  This doesn't look like something
> that could matter in practice.  If this does matter in practice this
> change deserves a comment and a fuller explanation.

This matters only for programs which 'read' permissions instead of 
'testing' them, but it's a challenge to imagine such program.

>
> The change itself seems reasonable and probably worth making as 
> general
> cleanup.
>

Let's consider it cleanup-only. The main idea is: /proc and /sys 
permissions must be the same as they are really the same.
