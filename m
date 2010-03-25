Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0CYSzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:55:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47519
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab0CYSzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:55:12 -0400
Date: Thu, 25 Mar 2010 11:55:35 -0700 (PDT)
Message-Id: <20100325.115535.197957345.davem@davemloft.net>
To: linux@dominikbrodowski.net
Cc: isdn@linux-pingi.de, henne@nachtwindheim.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100325.114548.12003085.davem@davemloft.net>
References: <201003251313.18144.isdn@linux-pingi.de>
	<20100325170240.GB5424@comet.dominikbrodowski.net>
	<20100325.114548.12003085.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 25 Mar 2010 11:45:48 -0700 (PDT)

> From: Dominik Brodowski <linux@dominikbrodowski.net>
> Date: Thu, 25 Mar 2010 18:02:40 +0100
> 
>> Karsten, will you carry these fixes upstream, or shall I do?
> 
> I'll apply them.

BTW, please CC: netdev on ISDN patches in the future.

I'll add some material to the MAINTAINERS if there isn't
a mention about this there already.
