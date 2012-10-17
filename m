Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab2JQG04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:26:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35604 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756120Ab2JQG0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:26:53 -0400
Message-ID: <1350455212.3072.27.camel@joe-AO722>
Subject: Re: [PATCH 1/2] cpufreq: Improve debug prints
From: Joe Perches <joe@perches.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com
Date: Tue, 16 Oct 2012 23:26:52 -0700
In-Reply-To: <CAKohpom6xHUmu2uYijdNVJHj6sFwJhYUYvXy+dN1a+WqzqTjZA@mail.gmail.com>
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
	 <1350452374.3072.19.camel@joe-AO722>
	 <CAKohpo=LL+wPcb97KNQvHbX0fzhnRBZjPsHXTj1PdYObuVVTgw@mail.gmail.com>
	 <1350453876.3072.23.camel@joe-AO722>
	 <CAKohpom6xHUmu2uYijdNVJHj6sFwJhYUYvXy+dN1a+WqzqTjZA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 11:47 +0530, Viresh Kumar wrote:
> On 17 October 2012 11:34, Joe Perches <joe@perches.com> wrote:
> > I believe you are quoting KBUILD_MODNAME
> 
> Yes. :(
> Far better output with this. Thanks.

Oh good, but please use a space between KBUILD_MODNAME
and the quoted ": ".

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

look at:
$ git grep -E -h "pr_fmt.*KBUILD_MODNAME" *|sort|uniq -c|sort -rn


