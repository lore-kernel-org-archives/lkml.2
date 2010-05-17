Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0EQCY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:24:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44740 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab0EQCYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n9oLV4firS0eMWx42Bj+uzBXkvQp581gTXjHMBt5gUCNFD7B+dn0hgAI90cnqXHqnm
         EgeMqf9qmVGdFRS6NHcD8s7pb4ZdpYT+LB7wFCh72y0MP7wfugkt7GE7ZT9zCE4j3xoX
         qqPlV3kGUg61ogqv6u/oF0/QeXR+x8bgWSNRw=
MIME-Version: 1.0
In-Reply-To: <1273065339-21669-5-git-send-email-jkacur@redhat.com>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
	 <1273065339-21669-5-git-send-email-jkacur@redhat.com>
Date: Mon, 17 May 2010 04:24:53 +0200
Message-ID: <AANLkTik5klKPS-AlIRbtBosc8NZXLcChyq5LMwwhC6-I@mail.gmail.com>
Subject: Re: [PATCH 4/6] ncpfs: BKL ioctl pushdown
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Petr Vandrovec <vandrove@vc.cvut.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/5 John Kacur <jkacur@redhat.com>:
> Convert ncp_ioctl to an unlocked_ioctl and push down the bkl into it.
>
> Signed-off-by: John Kacur <jkacur@redhat.com>


Applied, thanks.
