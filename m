Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030340Ab2AFOub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:50:31 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52533 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2AFOua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <NEXT-4f07092f473990.86346967@nextmail.ru>
References: <NEXT-4f07092f473990.86346967@nextmail.ru>
Date: Fri, 6 Jan 2012 20:20:29 +0530
Message-ID: <CAD2nsn1xf17MRwCfX26VhfOuXLuwMAsPkvGPBnMz51U=G8E+gw@mail.gmail.com>
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
>  > >  > can a find a fix
>  > >  > for both of them
>  > >
>  > > I am building kernel with pos<0 check added...
>  >
>  > thanks!  if it does not works, i have only one more idea(a patch
>  > which removes some suspicious code which abuses a pointer any way that
>  > has to be fixed properly ). otherwise i need to recreate the issue and
>  > capture the stack trace completely, put debug prints. i ran an
>  > overnight test but was unable to recreate the issue. later today AN  i
>  > got a crash accidentally but only once, after that never.
>
> What is a complete stack trace? Maybe I can configure console in some way and
> get the needed information.

just want to make sure , if we get the EIP and the exact line.
ath9k_config+0x115/0x780  points to ath_update_survey_stats

>
>

-- 
shafi
