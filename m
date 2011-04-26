Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab1DZErt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:47:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54525 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1DZEro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lqiZS3xk3cNQQJz9t3NqswtTPNqwZUaRko60N3tAiodHvXqX4ASVzICrwNKp0QtHeG
         dKkZWMheURDTZxP0/9V/LVktpZT52lfItoEX9W20itiFTV+B6tvZV6KDbAeF+DH1lSDR
         jMPMP6+H1JtHld2ytcWFCYwLujgWWp8SlQ0kc=
MIME-Version: 1.0
In-Reply-To: <20110426105518.F35D.A69D9226@jp.fujitsu.com>
References: <BANLkTi=WJytLPuKmiMYEHsVq4o=ESSY8MQ@mail.gmail.com>
 <20110426105045.F359.A69D9226@jp.fujitsu.com> <20110426105518.F35D.A69D9226@jp.fujitsu.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 26 Apr 2011 00:47:24 -0400
Message-ID: <BANLkTikkTBepMqsNfqvrhyQjTeHgeuNwGA@mail.gmail.com>
Subject: Re: (resend) [PATCH 1/4] blackfin: remove unused function
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 21:53, KOSAKI Motohiro wrote:
> platform_send_ipi() has old call-by-value cpumask_t fashon and
> it's unused.

looking at callers of platform_send_ipi_cpu(), it seems that there's
at least one place that could (should) be converted to
platform_send_ipi().  i'd rather update this func to the new api so i
can make that conversion.
-mike
