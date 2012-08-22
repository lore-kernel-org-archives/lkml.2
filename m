Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab2HVX7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:59:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19305 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2HVX7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:59:15 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-56-5035725231ac
Message-id: <50357250.4040308@samsung.com>
Date: Thu, 23 Aug 2012 08:59:12 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Peter Meerwald <pmeerw@pmeerw.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        broonie@opensource.wolfsonmicro.com, trivial@kernel.org
Subject: Re: [PATCH RESEND] extcon: fixing typos
References: <1345663663-4790-1-git-send-email-pmeerw@pmeerw.net>
 <1345663663-4790-3-git-send-email-pmeerw@pmeerw.net>
In-reply-to: <1345663663-4790-3-git-send-email-pmeerw@pmeerw.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jAd2gItMAg9W7eCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGhv97WQp2sFVs/b6YsYFxG2sXIyeHhICJxLyNMxghbDGJC/fW
	s4HYQgKLGCXaH1R1MXIB2V1MEs1TljCDJHgFtCSO7bsO1sAioCpxaGMjWAMbUHz/ixtANgeH
	qECExK9+DohyQYkfk++xgIRFBHwkDj0qBQkzC5RKPNp3gQkkLCxgINF1mQ9ia7nEwdOzwAZy
	CjhKHP09nRmiXEdif+s0NghbXmLzmrfMExgFZiFZMAtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBIfeM+kdjKsaLA4xCnAwKvHwZsSaBgixJpYVV+YeYpTgYFYS4b1hABTi
	TUmsrEotyo8vKs1JLT7EKM3BoiTOy99nGCAkkJ5YkpqdmlqQWgSTZeLglGpg9OT4Wd/Snfny
	+6RLqy9LSxZayG5rl3CPeTGtdrb/ftPHEzI/n712tbNv65IAEc/Jfyx79Z7a6yXZ+XSv/xO8
	3ZaNmY29eZ98bZQwh8nqV45vQ060n7222e9OxsRvLl/iY1MubL7zZ/tOZh7vjz+ezEif8c80
	gGfjTPGmNOurRx7IxwUFXstap8RSnJFoqMVcVJwIAOYmLVo5AgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 04:27 AM, Peter Meerwald wrote:

> Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
> ---
>  drivers/extcon/extcon_class.c |    8 ++++----
>  include/linux/extcon.h        |   18 +++++++++---------
>  2 files changed, 13 insertions(+), 13 deletions(-)
> 


This patch is already replied by Myungjoo Ham, so you can check it
following git repository.
-
http://10.90.51.51/cgi-bin/gitweb.cgi?p=linux-samsung;a=shortlog;h=refs/heads/extcon-for-next.

But, file name of 'extcon_class.c' has been modified from extcon_class.c
to extcon-class.c,
so i did modify and apply it. you can see patch which rename file
name(extcon-class.c, extcon-gpio.c)

http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=commit;h=0ea62503782699adf5757cb1d3cd9f880d13c48c

Thank you,
Chanwoo Choi
