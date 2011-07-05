Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1GEOzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:55:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56863 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1GEOzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:55:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: ashish.jangam@kpitcummins.com
Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v2
Date: Tue, 5 Jul 2011 16:55:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, sameo@openedhand.com,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        linaro-dev@lists.linaro.org
References: <1309876620.960.169.camel@L-0532.kpit.com>
In-Reply-To: <1309876620.960.169.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051655.27990.arnd@arndb.de>
X-Provags-ID: V02:K0:aMCCkHHjgzt9MvJF6W5rXNQyvnAxKse6k5KihRXld2m
 Ct6d3e8H1cSE4EWVAPOrKCENKvpEvOHsPomiVbgpFVJUQp9Rkl
 gXVTmuo91QG3zyv3u8EXuuS4HLZLIRZyiX1AU01PTnMoy5W5vo
 w47WppgzobLHc14VoO/cGr8YcBcEC4vZ8hIIus0KpHRkshMWQk
 cTmaw9jlJWnwIHtL7pKCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, ashishj3 wrote:
> The DA9052 is a highly integrated PMIC subsystem with supply domain flexibility
> to support wide range of high performance application.
> 
> It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> control and other functionality.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
