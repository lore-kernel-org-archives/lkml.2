Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab0KOTJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:09:01 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46514 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab0KOTIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Ic/yTLo03Gh/uWxtv2YdRsuceedU67Ym4evY2HyJF41HJEU6m5/SEh35sbXW5dYdfF
         wqaHNMtE477QrYjEs2OWyY74NRmpuyyXyfhEFP0UtpPMYkFqdKbFWOonVAFBxFEYA9Ud
         akpibECnIP8SzO0xPB1OhL1ssftH/h7Ch4i/o=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Marin Mitov <mitov@issp.bas.bg>
Subject: Re: [BUG]: skge not working (as module) in 2.6.37-rc1
Date: Mon, 15 Nov 2010 20:07:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.4.5; i686; ; )
Cc: Stephen Hemminger <shemminger@osdl.org>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <201011072345.52784.mitov@issp.bas.bg> <201011142045.14627.maciej.rutecki@gmail.com> <201011150555.59407.mitov@issp.bas.bg>
In-Reply-To: <201011150555.59407.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011152007.58264.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 15 listopada 2010 o 04:55:58 Marin Mitov wrote:
> On Sunday, November 14, 2010 09:45:14 pm Maciej Rutecki wrote:
> > On niedziela, 7 listopada 2010 o 22:45:52 Marin Mitov wrote:
> > > Hi Stephen,
> > > 
> > > skge as in 2.6.36 (and before) is working.
> > 
> > > As in 2.6.37-rc1 it is not:
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=22892
> > for your bug report, please add your address to the CC list in there,
> > thanks!
> 
> Hi Maciej,
> 
> It is already corrected, as in 2.6.37-rc1-git11.
> 
> Thanks.
> 
> Marin Mitov

Thanks for the update.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
