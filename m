Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1GaAaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:30:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54831 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab1GaA3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:29:55 -0400
Message-ID: <4E34A1E4.8040103@zytor.com>
Date: Sat, 30 Jul 2011 17:29:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
References: <1312067499.22074.59.camel@i7.infradead.org> <1312067670.22074.61.camel@i7.infradead.org> <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com> <4E34998D.8060806@zytor.com> <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
In-Reply-To: <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2011 05:05 PM, Arnaud Lacombe wrote:
>>
>> Why????
>>
> Because kconfig might not be ran exclusively from a fully controlled
> and restricted environment ? Not to mention that it is used by other
> people than the linux kernel folks.
> 

I'm sorry, but whitelisting specific options is an absolutely idiotic
way to deal with that.  The options use a specific namespace (CONFIG_*),
and only allowing some options to be set on the command line, but not
others, is a serious violation of the principle of least surprise.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

