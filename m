Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0JWLsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:48:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47583 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab0JWLsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:48:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CC2CB4B.8040600@s5r6.in-berlin.de>
Date: Sat, 23 Oct 2010 13:47:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: nosy: char device is not seekable
References: <tkrat.42de7ec9907e63aa@s5r6.in-berlin.de> <201010131554.43089.arnd@arndb.de> <tkrat.f853df65a5128ca0@s5r6.in-berlin.de> <201010231057.18135.arnd@arndb.de>
In-Reply-To: <201010231057.18135.arnd@arndb.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Most likely you also want the nonseekeable_open, which would prevent
> both llseek and pread/pwrite, whereas leaving out llseek currently
> only prevents llseek.

Right, thanks for the reminder.
-- 
Stefan Richter
-=====-==-=- =-=- =-===
http://arcgraph.de/sr/
