Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1FDVlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 17:41:24 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:44427 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1FDVlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 17:41:24 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DEAA677.2010404@elektron.elka.pw.edu.pl>
Date: Sat, 04 Jun 2011 23:41:11 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Machine panicking with 2.6.39.1 boots correctly with acpi=off
References: <4DEA8FDD.1060905@elektron.elka.pw.edu.pl>
In-Reply-To: <4DEA8FDD.1060905@elektron.elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same machine boots and works correctly with 2.6.39.1 when I add 
"acpi=off" boot parameter. Is the problem located somewhere in the acpi
related code?
-- 
Regards,
Wojtek
