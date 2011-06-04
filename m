Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1FDWBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 18:01:49 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:44480 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab1FDWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 18:01:48 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DEAAB42.8070704@elektron.elka.pw.edu.pl>
Date: Sun, 05 Jun 2011 00:01:38 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: acpi=off switches off also HT support, maybe it is something SMP
 related?
References: <4DEA8FDD.1060905@elektron.elka.pw.edu.pl> <4DEAA677.2010404@elektron.elka.pw.edu.pl>
In-Reply-To: <4DEAA677.2010404@elektron.elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 04.06.2011 23:41, wzabolot@elektron.elka.pw.edu.pl pisze:
> The same machine boots and works correctly with 2.6.39.1 when I add
> "acpi=off" boot parameter. Is the problem located somewhere in the acpi
> related code?

I've just stated, that acpi=off switches off also HT support.
However 2.6.39.1 works correctly on my another dual-core machine.
May it be something, which fails on HT enabled CPU but works correctly
on SMP machine?
-- 
Regards,
Wojtek
