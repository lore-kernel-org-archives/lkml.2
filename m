Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab1F1SXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:23:38 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42765 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759398Ab1F1SWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:22:31 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: slab vs lockdep vs debugobjects
Date: Tue, 28 Jun 2011 20:22:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc4; KDE/4.6.3; i686; ; )
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <1308592080.26237.114.camel@twins> <201106262204.25710.maciej.rutecki@gmail.com> <1309124100.4756.0.camel@twins>
In-Reply-To: <1309124100.4756.0.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106282022.23269.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 26 czerwca 2011 o 23:35:00 Peter Zijlstra wrote:
> On Sun, 2011-06-26 at 22:04 +0200, Maciej Rutecki wrote:
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=36912
> > for your bug report, please add your address to the CC list in there,
> > thanks!
> 
> How the hell does that improve things?
Sorry for the noise, I wrong assumed that is regression, and problem does not 
occured before. Rafael already removed it from regression list.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
