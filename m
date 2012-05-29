Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2E2ROx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:14:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53194 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab2E2ROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:14:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120529115900.GA31679@richard>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<4F95B17B.3030401@redhat.com>
	<20120514015536.GA3331@richard>
	<CAE9FiQUjxH+LWy2zbbL6TVQSMZ44i9grFBZf0ZZQFPEWRKANMw@mail.gmail.com>
	<20120514064615.GB26605@richard>
	<CAE9FiQUuHFoEXMz_Va+FOGnqEbi9=cnnoSB+h7Ug2e4Y2sFTGQ@mail.gmail.com>
	<20120516011833.GA6599@richard>
	<CAE9FiQVUcYu-KM8fBs3zO5ZnL9jxHmJSN6-Ue5-kdC-niM6=Jw@mail.gmail.com>
	<20120529115900.GA31679@richard>
Date: Tue, 29 May 2012 10:14:51 -0700
X-Google-Sender-Auth: BenxFhnzpXIw8zodMHhfCW3iwNc
Message-ID: <CAE9FiQWO1C76ppjZF4Lm4FVpQYPRv5ZirGp9iOM3pm-xrm3Epg@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 4:59 AM, Richard Yang
<weiyang@linux.vnet.ibm.com> wrote:
>
> I think about this issue again, this behavior of kernel will bring some
> unconvenience to the user.
>
> Do you think the kernel could handle this situation?

in this extreme case, you may need user to do some comprise.

We should always try to use setting from BIOS if it is sane.

Yinghai
