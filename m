Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2IDQGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:06:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34254 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2IDQGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:06:10 -0400
Message-ID: <504626CB.60601@gmail.com>
Date: Tue, 04 Sep 2012 10:05:31 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Maciek Borzecki <maciek.borzecki@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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

Why not set the PATH to make the toolchain's version the one used by perf?

David

