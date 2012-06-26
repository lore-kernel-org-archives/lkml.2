Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2FZEkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:40:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42753 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2FZEkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:40:52 -0400
Message-ID: <4FE93D51.7090709@gmail.com>
Date: Mon, 25 Jun 2012 22:40:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Rosenberg <mrosenberg@mozilla.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf report does not get along with perf record -A
References: <443195725.4576626.1340669457668.JavaMail.root@mozilla.com>
In-Reply-To: <443195725.4576626.1340669457668.JavaMail.root@mozilla.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/12 6:10 PM, Martin Rosenberg wrote:
> I'm working under the assumption that if I want to collect statistics from multiple runs of a program, I can do this by running
> perf record prog; perf record -A prog; perf record -A prog
>
> I've found that running perf record twice results in perf report hanging, and running it more than twice results in perf report first spewing a message about invalid formats, then crashing.
> A log of the session, as well as the binary, its input and perf.data can be found at:

What does 'perf --version' show?

David
