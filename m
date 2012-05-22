Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab2EVPxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:53:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49712 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2EVPxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:53:36 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: tcp timestamp issues with google servers
References: <87r4ujno34.fsf@tucsk.pomaz.szeredi.hu>
	<1337278363.3403.39.camel@edumazet-glaptop>
	<87zk90s0em.fsf@tucsk.pomaz.szeredi.hu>
	<1337701259.3361.208.camel@edumazet-glaptop>
Date: Tue, 22 May 2012 17:54:07 +0200
In-Reply-To: <1337701259.3361.208.camel@edumazet-glaptop> (Eric Dumazet's
	message of "Tue, 22 May 2012 17:40:59 +0200")
Message-ID: <87mx50rz34.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On Tue, 2012-05-22 at 17:25 +0200, Miklos Szeredi wrote:
>
>> So it appears.  The IP address is certainly registered to Google.
>
> Good, but you could have a middlebox doing transparent proxying.
>
> The SYNACK could be send by this box.

Okay.  Is there a way to find out whether there is a middlebox or not?

Thanks,
Miklos

