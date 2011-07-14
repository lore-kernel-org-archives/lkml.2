Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1GNLM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:12:29 -0400
Received: from mail001.aei.ca ([206.123.6.130]:40985 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab1GNLM2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:12:28 -0400
From: Ed Tomlinson <edt@aei.ca>
To: maciej.rutecki@gmail.com
Subject: Re: [BUG] with threadirqs active
Date: Thu, 14 Jul 2011 07:12:23 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc6-crc+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201107110810.35716.edt@aei.ca> <201107141013.41443.maciej.rutecki@gmail.com>
In-Reply-To: <201107141013.41443.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107140712.24189.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 July 2011 04:13:41 Maciej Rutecki wrote:
> On poniedziałek, 11 lipca 2011 o 14:10:35 Ed Tomlinson wrote:
> > Hi,
> > 
> > I've be running with threaded irq since they became available.  Today,
> > runing 3.0.0-rc5, my box stalled.  After reboot this was in messages
> > (serial console was not active):
> > 
> 
> It is regression, older kernels (eg. 2.6.39) work OK?

Hard to say.  I've only had it happen once and do not have a recipe to recreate
it.  I reported it so it would be on record when to help as more happen.

Thanks
Ed
