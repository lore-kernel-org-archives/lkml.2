Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab2HQOqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:46:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62829 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab2HQOqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:46:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH V4 2/5] clk: mmp: add clock definition for pxa168
Date: Fri, 17 Aug 2012 14:46:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, chao.xie@marvell.com
References: <1345183330-20244-1-git-send-email-xiechao.mail@gmail.com> <201208171134.32195.arnd@arndb.de> <CADApbejwG5F5pEicWSAb0308npupfHkE0fqTweec9ve2ZzkREw@mail.gmail.com>
In-Reply-To: <CADApbejwG5F5pEicWSAb0308npupfHkE0fqTweec9ve2ZzkREw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171446.23851.arnd@arndb.de>
X-Provags-ID: V02:K0:Kb+0rU/erAowcr8b5aH/qlEwBKWilIa73bHQwGuyspO
 oQaj0UuOAosW+3/mYsIrYEPwlip+RAB3sXOwgnYXKpOx9Y/vr5
 WthqS3JBKgEHfFL+f1pbwvwP6bZ4mPIpbMzptRiidVraC2leMZ
 gQAIQuMkIYAkvX3DXo64dPu1VjACcwaHt5xOhcp0mt55Uah5j/
 51GnOFl1TW20ebC3UlAP/5R6w3EgHmLsPKKRJCHEQlesuj7Azc
 PYPxM31bBrcwGG7KBb7HndXGAgEwMrTEG6D4dg2s19V63V5QzO
 YgDVqwd74alEJ9rV3LukAgO8CuJRjRdemC1sYLtvEaq2n92LRr
 EE6wp5PHRO2V8mbhz/Rg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2012, Chao Xie wrote:
> The clock tree is formatted into a table, and i used perl to generate
> the code based on the table. In order to make the indent clearly, i
> used the scripts/Lindent to automatically format the .c file.
> I have tried to searched the parameter for indent, but i do not find
> that anything can remove the the style of newline after "=", so in
> order to not format the file line by line, i just accept the results
> of indent.
> Do you have any idea about it?

No easy solution. I don't normally trust lindent. Especially if you want
to bend the rules slightly, it's often better to manually edit the
output of lindent.

	Arnd
