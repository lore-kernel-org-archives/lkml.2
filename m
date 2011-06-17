Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1FQRa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:30:26 -0400
Received: from 173-164-233-81-SFBA.hfc.comcastbusiness.net ([173.164.233.81]:39656
	"EHLO email.techspecs.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754779Ab1FQRaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:30:21 -0400
Message-ID: <8580d88821b047c208fa769799eb9626.squirrel@mail.techspecs.com>
In-Reply-To: <53e44025a84a55558f4fb1dea8642ab6.squirrel@mail.techspecs.com>
References: <53e44025a84a55558f4fb1dea8642ab6.squirrel@mail.techspecs.com>
Date: Fri, 17 Jun 2011 10:30:19 -0700
Subject: Re: PROBLEM: AMD Zacate E350 shows only 2.6GB memory when 8GB
 installed
From: chrish@techspecs.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you to those who gave suggestions about the issue I saw. Updating
the kernel to 2.6.39, for me, fixed the problem.

Best,
  Chris


> Hi,
>
>    I tried this on Fedora 14 and OpenSuse 11.4 and both exhibit the same
> behavior. 8GB is installed but only 2698476 shows available for use
> using "top" or "free". dmidecode shows 2 4GB DIMMs and the BIOS reports
> 8GB of memory. Memtest reports and tests 8GB of memory. I Googled the
> issue and it seems there are others that also report the same. What to
> do? Thank you.
>
> Best,
>   Chris
>
>


