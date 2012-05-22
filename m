Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2EVQiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:38:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57303 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2EVQiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:38:20 -0400
MIME-Version: 1.0
In-Reply-To: <87mx50rz34.fsf@tucsk.pomaz.szeredi.hu>
References: <87r4ujno34.fsf@tucsk.pomaz.szeredi.hu>
	<1337278363.3403.39.camel@edumazet-glaptop>
	<87zk90s0em.fsf@tucsk.pomaz.szeredi.hu>
	<1337701259.3361.208.camel@edumazet-glaptop>
	<87mx50rz34.fsf@tucsk.pomaz.szeredi.hu>
Date: Tue, 22 May 2012 09:38:19 -0700
Message-ID: <CAGK4HS9cGnOcoLAL1pggWvMG1B40rWyqc3BHsddUvnii4EvTcQ@mail.gmail.com>
Subject: Re: tcp timestamp issues with google servers
From: Vijay Subramanian <subramanian.vijay@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Okay.  Is there a way to find out whether there is a middlebox or not?
>

Miklos,
Maybe tcptraceroute[1] can help you figure this out.

Hope this helps.
Vijay

[1] http://michael.toren.net/code/tcptraceroute/
