Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2IYHZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:25:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63767 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab2IYHZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:25:41 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Subject: Re: RFE: tty color features
From: Dave Yost <Dave@Yost.com>
In-Reply-To: <alpine.LNX.2.01.1209250901040.25195@nerf07.vanv.qr>
Date: Tue, 25 Sep 2012 00:25:36 -0700
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DF2CBE42-E936-4072-BA09-0764A8293941@Yost.com>
References: <D1425869-534B-4AD9-BF2E-956A76E29894@Yost.com> <alpine.LNX.2.01.1209250901040.25195@nerf07.vanv.qr>
To: Jan Engelhardt <jengelh@inai.de>
X-Mailer: Apple Mail (2.1498)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-09-25, at 12:02 AM, Jan Engelhardt <jengelh@inai.de> wrote:

> On Tuesday 2012-09-25 08:01, Dave Yost wrote:
> 
>> It would be nice to be able to specify fg/bg colors at the tty level, 
>> so that echoed characters can be colorized.
> 
> The tty layer does not know what $TERM is used, so it cannot reliably 
> produce any codes.

The driver will reliably produce the codes it has been told to produce by the shell or by the user tells, using ioctl or stty commands.

This reminds me of a “D’Oh!” moment aeons ago, when I suggested to Mark Horton that TERM should not be an environment variable. It should be a settable property of the tty. Mark agreed, but neither he nor I felt like going to bat for it back then. This architectural mistake should still be fixed, IMHO. Perhaps the modern world of 2012 would be able to absorb this change, if implemented properly.

BTW, I did significant work on the Fortune Systems tty driver in (cough) 1982-1983.

* Horton, Mark. "The New Curses and Terminfo Package". USENIX Conference Proceedings. Summer 1982. Boston, MA: USENIX. pp. 79–91

> But you can edit GNU screen because it has that 
> knowledge and the fds.

