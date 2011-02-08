Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab1BHGqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 01:46:40 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:57823 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab1BHGqi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 01:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <201102072115.20858.edt@aei.ca>
References: <201102051417.58953.edt@aei.ca> <201102071009.51238.oneukum@suse.de>
 <201102071920.22543.edt@aei.ca> <201102072115.20858.edt@aei.ca>
From: "Gadiyar, Anand" <gadiyar@ti.com>
Date: Tue, 8 Feb 2011 12:16:16 +0530
Message-ID: <AANLkTinpKwe2vWH3=Ur+N76a6KyfuFp0V-EznXXS7m+p@mail.gmail.com>
Subject: Re: [BUG] usb problems in .38-rc3+
To: Ed Tomlinson <edt@aei.ca>
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 7:45 AM, Ed Tomlinson <edt@aei.ca> wrote:
> I tried bisecting without much luck.  It started with about 4000 commits to check.  It was still bad
> when it reached the first 1000 commits post .37.  Then all boots started crashing.  I think its possible
> to restrict a bisect to a directory - if so, what dir should I try?
>

Maybe drivers/ or drivers/usb would be enough for a first attempt?
I usually start there.

You could just do:

git bisect start -- [path]

to restrict bisection to commits that touch [path].

- Anand
