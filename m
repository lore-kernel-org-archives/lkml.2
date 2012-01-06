Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030301Ab2AFOfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:35:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61051 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2AFOfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:35:04 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f06ee5c00c505.33406970@nextmail.ru>
References: <NEXT-4f06ee5c00c505.33406970@nextmail.ru>
Date: Fri, 6 Jan 2012 20:05:03 +0530
Message-ID: <CAD2nsn0PJU+ZuZfuVOzsvN0yq76JdgYpwkoeS8yfvKQSiO8VfA@mail.gmail.com>
Subject: Re: ath9k crash 3.2-rc7
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MR <g7af0ec1e3ea1e7b1@nextmail.ru>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/6 MR <g7af0ec1e3ea1e7b1@nextmail.ru>:
>  >:(  i had put those warnings to prevent the crash itself and what's causing
>  >it.
>  > may be i had missed that pos can be < 0 in addition to (pos > 37).
>  > i am just looking at those areas of code for some other issue. hope i
>  > can a find a fix
>  > for both of them
>
> I am building kernel with pos<0 check added...

thanks!  if it does not works, i have only one more idea(a patch
which removes some suspicious code which abuses a pointer any way that
has to be fixed properly ). otherwise i need to recreate the issue and
capture the stack trace completely, put debug prints. i ran an
overnight test but was unable to recreate the issue. later today AN  i
got a crash accidentally but only once, after that never.

>
> I hoped for some ad-hoc stress-test recommendation, but I guess this will have
> to wait.
>
>



-- 
shafi
