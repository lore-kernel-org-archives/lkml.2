Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab1KPApm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:45:42 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:41443 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1KPApk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:45:40 -0500
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Nov 2011 19:45:40 EST
Message-ID: <4EC30511.6030807@hp.com>
Date: Tue, 15 Nov 2011 16:34:25 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Grant Grundler <grundler@chromium.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Allan Chou <allan@asix.com.tw>, Freddy Xin <freddy@asix.com.tw>
Subject: Re: [PATCH 5/5] net-next:asix: v2 update VERSION only
References: <1321318357-17723-1-git-send-email-grundler@chromium.org> <21257.1321403368@turing-police.cc.vt.edu>
In-Reply-To: <21257.1321403368@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 04:29 PM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 14 Nov 2011 16:52:37 PST, Grant Grundler said:
>
>> -#define DRIVER_VERSION "26-Sep-2011"
>> +#define DRIVER_VERSION "08-Nov-2011"
>
> Aren't these sort of things more than a tad silly for an in-kernel driver?

Probably depends on whether or not a distro back-ports something from 
upstream.

rick jones

