Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab0FVSjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:39:21 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43181 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0FVSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:39:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C21034C.7060309@s5r6.in-berlin.de>
Date: Tue, 22 Jun 2010 20:39:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] firewire: core: no need to track irq flags in	bm_work
References: <tkrat.96072b90a5c06bb3@s5r6.in-berlin.de> <20100622093618.GC26304@frolo.macqel> <4C20A1DE.2040503@s5r6.in-berlin.de> <20100622142649.GA18061@frolo.macqel>
In-Reply-To: <20100622142649.GA18061@frolo.macqel>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> Thanks for the clear explanation, and sorry for your wasted time.

Oh, no problem.  It helps that somebody actually looks at these patches
and asks if something looks illogical.  I for one am on record to have
posted patches that got things backwards. :-)
-- 
Stefan Richter
-=====-==-=- -==- =-==-
http://arcgraph.de/sr/
