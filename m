Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2J3HzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:55:10 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:56552 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2J3HzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <508F8779.8070300@linaro.org>
References: <5afab1ebe83e4361f1fd75bbea0c559af195bf02.1351529738.git.viresh.kumar@linaro.org>
	<1351540778.2721.7.camel@bwh-desktop.uk.solarflarecom.com>
	<CAKohponL_3m2KVytiWm8ZHyB5aimk8CzGrqr5J0LMy8MFGodHg@mail.gmail.com>
	<CAKohponOKk5e2Sxyhjw-XvzVxF3tNp66rsnYCwvwHazAPAauKw@mail.gmail.com>
	<508F8779.8070300@linaro.org>
Date: Tue, 30 Oct 2012 13:25:07 +0530
Message-ID: <CAKohpokmfFSFsADmtOyN9JRCX8aVdNs+tDFhUQuM6sSQ+dFfUA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa/slave: Fix compilation warnings
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2012 13:23, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> From: Viresh Kumar <viresh.kumar@linaro.org>

>>  config NET_DSA_TAG_DSA
>> -     bool
>> +     bool "Original DSA packet tagging format"
>> +     select NET_DSt
>
> typo NET_DSA

Unbelievable mistake :(

Will fix it after some reviews now :)

--
viresh
