Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0HHIuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 04:50:23 -0400
Received: from sh.osrg.net ([192.16.179.4]:45662 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab0HHIuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 04:50:20 -0400
Date: Sun, 8 Aug 2010 17:50:13 +0900
To: janos.haar@netcenter.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: scsi emulation - question
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <0f7601cb35be$d93998c0$0400a8c0@dcccs>
References: <0f7601cb35be$d93998c0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100808174914A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 08 Aug 2010 17:50:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Aug 2010 01:26:45 +0200
"Janos Haar" <janos.haar@netcenter.hu> wrote:

> I am looking for a solution wich can emulate SCSI device from a block device 
> like loop.
> I need the sg device but not for special commands, but for reading and 
> writing only.
> I have found only one solution until now, but i want to find better and 
> faster.
> The actually working is ISCSI target and initiator in one pc.
> But this opens up port, and makes a lot of IP packets even if i use lo for 
> this, wich is only a waste of time and resources.

scsi-debug should work for you.
