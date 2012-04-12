Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2DLLOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:14:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2DLLOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:14:41 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 00/13] common clk framework misc fixes
Date: Thu, 12 Apr 2012 11:14:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204121114.38825.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:17T0+8q5YjGp7/+/8KMb/6oI4Ka5vqek2JShjbz+ur1
 zOaNUSjN9e9m2LvHOLjG04rhG1f7QOALf4sM0hozEqrgNUJe4C
 PbNHKTUwjM8IgqEHYEHJZjyV7pB1x2RWTsWwDjqtsgKTSJJSZ5
 YxIZXQywdWvLMLlmcOzgnvgoRpAMDNo4LDlBnyCrK7lYAsq70a
 5IezkydQvP3KJgtXehFR3tyurJBHAYlugUFB28eoE11/ItBcQB
 v+jl9gkxVHoTqgKkHTwLTTJqz29ALT3pDeItoNnaAiirDhuGgv
 tL707+rRzE/cKieKZMUK7XR4c7SLwJg4qBtlts6C6KcvSKHxYF
 PQowqHHln8kilALh6trBfHk0rFZFlvm38BXmexJg+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2012, Mike Turquette wrote:
> This series collects many of the fixes posted for the recently merged
> common clock framework as well as some general clean-up.  Most of the
> code classifies as a clean-up moreso than a bug fix; hopefully this is
> not a problem since the common clk framework is new code pulled for 3.4.
> 
> Patches are based on v3.4-rc2 and can be pulled from:
> git://git.linaro.org/people/mturquette/linux.git v3.4-rc2-clk-fixes
> 
> Please let me know I missed any critical fixes that were posted to the
> list already.
> 
> Arnd & Olof, if there are no objections to these changes can this get
> pulled through the arm-soc tree?

I think pulling it in through the arm-soc tree is still ok, but it's
borderline because of the size and patch 13 is probably too big,
in addition to the comments that were made there.

Let's pull patches 1 through 12 in to a separate series that we don't
mix with the other bug fixes. Mike, please send a pull request with the
Acks added in.

	Arnd
