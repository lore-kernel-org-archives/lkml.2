Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0DVFoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 01:44:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56231
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab0DVFoa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 01:44:30 -0400
Date: Wed, 21 Apr 2010 22:44:35 -0700 (PDT)
Message-Id: <20100421.224435.168594051.davem@davemloft.net>
To: diego@giagio.com
Cc: agimenez@sysvalve.es, linux-kernel@vger.kernel.org, dborca@yahoo.com,
       James.Bottomley@hansenpartnership.com, ralf@linux-mips.org,
       gregkh@suse.de, jonas.sjoquist@ericsson.com, torgny.johansson@gmail.com,
       steve.glendinning@smsc.com, dbrownell@users.sourceforge.net,
       omar.oberthur@gmail.com, remi.denis-courmont@nokia.com,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb: Add new driver ipheth
From: David Miller <davem@davemloft.net>
In-Reply-To: <x2g1b0798831004210715h37253bc5y74baf86556aea7c5@mail.gmail.com>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
	<1271615719-14928-1-git-send-email-agimenez@sysvalve.es>
	<x2g1b0798831004210715h37253bc5y74baf86556aea7c5@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Diego Giagio <diego@giagio.com>
Date: Wed, 21 Apr 2010 11:15:15 -0300

> On Sun, Apr 18, 2010 at 3:35 PM, L. Alberto Giménez
> <agimenez@sysvalve.es> wrote:
>> From: Diego Giagio <diego@giagio.com>
>>
>> Add new driver to use tethering with an iPhone device. After initial submission,
>> apply fixes to fit the new driver into the kernel standards.
>>
>> There are still a couple of minor (almost cosmetic-level) issues, but the driver
>> is fully functional right now.
>>
> 
> Signed-off-by: Diego Giagio <diego@giagio.com>
> Cc: Daniel Borca <dborca@yahoo.com>

Applied, thanks everyone.
