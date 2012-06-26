Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab2FZFEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:04:54 -0400
Received: from nat.fw1.corp.phx1.mozilla.net ([63.245.216.64]:40610 "EHLO
	zmmta2.mail.corp.phx1.mozilla.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752066Ab2FZFEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:04:53 -0400
Date: Mon, 25 Jun 2012 22:04:52 -0700 (PDT)
From: Martin Rosenberg <mrosenberg@mozilla.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <1090364757.4589034.1340687092722.JavaMail.root@mozilla.com>
In-Reply-To: <4FE93D51.7090709@gmail.com>
Subject: Re: perf report does not get along with perf record -A
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.77.200]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Derp.  I went through all of that effort to make sure I had recorded everything about my setup, and I forgot the versiou

perf version 3.2.17

built unpatched from a 3.4.4 tarball

----- Original Message -----
From: "David Ahern" <dsahern@gmail.com>
To: "Martin Rosenberg" <mrosenberg@mozilla.com>
Cc: linux-kernel@vger.kernel.org
Sent: Monday, June 25, 2012 9:40:49 PM
Subject: Re: perf report does not get along with perf record -A

On 6/25/12 6:10 PM, Martin Rosenberg wrote:
> I'm working under the assumption that if I want to collect statistics from multiple runs of a program, I can do this by running
> perf record prog; perf record -A prog; perf record -A prog
>
> I've found that running perf record twice results in perf report hanging, and running it more than twice results in perf report first spewing a message about invalid formats, then crashing.
> A log of the session, as well as the binary, its input and perf.data can be found at:

What does 'perf --version' show?

David
