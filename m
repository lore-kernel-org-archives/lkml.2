Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab0JYUiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:38:14 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39023 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab0JYUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:38:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CC5EAAD.2040408@s5r6.in-berlin.de>
Date: Mon, 25 Oct 2010 22:38:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Elvis Dowson <elvis.dowson@mac.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to prevent + being appended to kernel image name
References: <D1A25074-F603-450B-BF77-FED5FAFC54C5@mac.com>
In-Reply-To: <D1A25074-F603-450B-BF77-FED5FAFC54C5@mac.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elvis Dowson wrote:
> How can I prevent the + symbol from being prefixed to the kernel image name? 

scripts/setlocalversion is the culprit.  Read at the bottom of the file under
which conditions it adds the +.
-- 
Stefan Richter
-=====-==-=- =-=- ==--=
http://arcgraph.de/sr/
