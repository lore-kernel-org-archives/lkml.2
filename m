Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0KIRDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:03:30 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:59044 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0KIRD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:03:29 -0500
Date: Tue, 9 Nov 2010 09:03:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: <linux-kernel@vger.kernel.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 0/2] FAT unified kernel messages
Message-Id: <20101109090313.c55168ac.randy.dunlap@oracle.com>
In-Reply-To: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Nov 2010 17:55:16 +0100 Alexey Fisher wrote:

> Hi all,
> i do not know best place to send patches for FAT fs, so i send it here.

This mailing list is fine, but you should also Cc: the maintainer as listed
in the MAINTAINERS file:

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


> This patchset add function fat_msg and remplace all printk to use it.
> The major differnce is - it add device name to all messages. 
> 
> For example old log:
>  FAT: im filed.
> new one:
>  FAT-fs (sda1): im filed.
> 
> Second reson is, to make FAT logs more grep frendly. So you can grep by "-fs"
> for (EXT[4,3,2] and FAT), or by device.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
