Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1GNINs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:13:48 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46495 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1GNINq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:13:46 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Ed Tomlinson <edt@aei.ca>
Subject: Re: [BUG] with threadirqs active
Date: Thu, 14 Jul 2011 10:13:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201107110810.35716.edt@aei.ca>
In-Reply-To: <201107110810.35716.edt@aei.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107141013.41443.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 11 lipca 2011 o 14:10:35 Ed Tomlinson wrote:
> Hi,
> 
> I've be running with threaded irq since they became available.  Today,
> runing 3.0.0-rc5, my box stalled.  After reboot this was in messages
> (serial console was not active):
> 

It is regression, older kernels (eg. 2.6.39) work OK?

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
