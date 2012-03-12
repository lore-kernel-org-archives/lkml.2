Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab2CLPwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:52:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49407 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2CLPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:52:09 -0400
Message-ID: <4F5E1BA4.2000209@gmail.com>
Date: Mon, 12 Mar 2012 09:52:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf: Integrate logging facilities
References: <4F5DC8D9.9030608@lge.com>
In-Reply-To: <4F5DC8D9.9030608@lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12 3:58 AM, Namhyung Kim wrote:
> This is a rough idea and there can be things I am missing. So I need to
> listen to your advices.

What Arnaldo proposed was having core, library code return error codes 
and not print anything to the user. Higher layers (commands only?) can 
take the return error code and pass it to perf_<subsystem>_strerror() to 
dump a user friendly string for the error. See

http://lkml.org/lkml/2012/2/13/302

David
