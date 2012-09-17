Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2IQHfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:35:13 -0400
Received: from void.printf.net ([89.145.121.20]:45799 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab2IQHfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:35:11 -0400
From: Chris Ball <cjb@laptop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: sdio: Fix PM_SLEEP related build warnings
References: <1344504741-12081-1-git-send-email-thierry.reding@avionic-design.de>
	<201208091200.11161.rjw@sisk.pl>
Date: Mon, 17 Sep 2012 03:35:22 -0400
In-Reply-To: <201208091200.11161.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 9 Aug 2012 12:00:10 +0200")
Message-ID: <m3pq5lyudh.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 09 2012, Rafael J. Wysocki wrote:
> On Thursday, August 09, 2012, Thierry Reding wrote:
>> Power management callbacks defined by SIMPLE_DEV_PM_OPS are only used if
>> the PM_SLEEP Kconfig symbol has been defined. If not, the compiler will
>> complain about them being unused. However, since the callback for this
>> driver doesn't do anything it can just as well be dropped.
>> 
>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks, pushed to mmc-next for 3.7.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
