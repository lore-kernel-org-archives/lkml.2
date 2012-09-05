Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab2IEVL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:11:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48879 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287Ab2IEVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:11:55 -0400
Message-ID: <5047C017.5000707@gmail.com>
Date: Wed, 05 Sep 2012 15:11:51 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Maciek Borzecki <maciek.borzecki@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf: allow user to indicate path to objdump in command
 line
References: <1346754750.16299.3.camel@localhost.localdomain>
In-Reply-To: <1346754750.16299.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/4/12 4:32 AM, Maciek Borzecki wrote:
> When analyzing perf data from hosts of other architecture than one of the local
> host it's useful to call objdump that is part of a toolchain for that
> architecture. Instead of calling regular objdump, call one that user specified
> in command line.
>
> Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>


Acked-by: David Ahern <dsahern@gmail.com>
