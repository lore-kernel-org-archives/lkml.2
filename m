Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0DALaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:30:55 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:40388 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0DALat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:30:49 -0400
Message-ID: <4BB483E1.9050203@grupopie.com>
Date: Thu, 01 Apr 2010 12:30:41 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Performance disparity, problem found
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, all

I have two machines that show very different performance numbers.

After digging a little I found out that the first machine has, in
/proc/cpuinfo:

model name      : Intel(R) Celeron(R) M processor         1.00GHz

while the other has:

model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz

and that seems to be the main difference.

Now the problem is that /proc/cpuinfo is read only. Would it be possible
to make /proc/cpuinfo writable so that I could do:

echo -n "model name      : Intel(R) Core(TM)2 Quad CPU    Q6600  @
2.40GHz" > /proc/cpuinfo

in the first machine and get a performance similar to the second machine?

-- 
Paulo Marques - www.grupopie.com

"To know recursion, you must first know recursion."
