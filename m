Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1FQGyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 02:54:32 -0400
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:40566 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab1FQGy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 02:54:29 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jun 2011 02:54:29 EDT
Message-ID: <4DFAF9A3.6090802@ladisch.de>
Date: Fri, 17 Jun 2011 08:52:19 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: chrish@techspecs.com
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: AMD Zacate E350 shows only 2.6GB memory when 8GB installed
References: <53e44025a84a55558f4fb1dea8642ab6.squirrel@mail.techspecs.com>
In-Reply-To: <53e44025a84a55558f4fb1dea8642ab6.squirrel@mail.techspecs.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chrish@techspecs.com wrote:
>    I tried this on Fedora 14 and OpenSuse 11.4 and both exhibit the same
> behavior. 8GB is installed but only 2698476 shows available for use
> using "top" or "free".

/proc/iomem?
dmesg?
