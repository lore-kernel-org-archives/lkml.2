Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1G1NoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:44:07 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44359 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1G1NoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <1311857213.26660.YahooMailNeo@web137313.mail.in.yahoo.com>
References: <1311857035.41442.YahooMailNeo@web137319.mail.in.yahoo.com>
	<1311857213.26660.YahooMailNeo@web137313.mail.in.yahoo.com>
Date: Thu, 28 Jul 2011 16:44:04 +0300
Message-ID: <CAMhs6YwYBwGpCxgoGJyi3w3w5LTeM1fftG47bfh0-rr1eqC9zA@mail.gmail.com>
Subject: Re: Linux child process does not core dump
From: Maxin B John <maxin.john@gmail.com>
To: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srinivas,

On Thu, Jul 28, 2011 at 3:46 PM, Srinivas Nayak
<sinu_nayak2001@yahoo.co.in> wrote:
>
> In my program, I fork() to get a child process.
> Because of some problem, child process terminates by a segmentation fault.
> Parent process is still running.
>
> I have compiled my code with -g option.
> I have done: ulimit -c unlimited.
>
> I am not getting core dump of the child process.
>
> How can I get the core dump of child process?

You can call setrlimit(2) from the child process to get core dump.

Best Regard,
Maxin B. John
