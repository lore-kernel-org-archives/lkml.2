Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1ADXkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:40:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51105 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab1ADXkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:40:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qg6gkekO8m0k8BzbXFtogIUImqYVBnppUrtixt1PIJ4+1vDekf5DBbHaRiJo5BfK+4
         1uv4rXH0onidC3kmKgQGHjdamozxq5bgwe2Go5g0E43lNR4I2aINkPhF3lIEO9KBo76O
         APRUF8GlZidL+FD61NiKXQM1BSGG4q/j6TR4E=
Message-ID: <4D23AFE8.3040207@gmail.com>
Date: Wed, 05 Jan 2011 00:40:24 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
CC: Peter Zijlstra <peterz@infradead.org>, a.p.zijlstra@chello.nl,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>, riel@redhat.com,
        Hillf Danton <dhillf@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Fwd: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function]
References: <1294164920.6169.199.camel@Palantir> <4D23AF8A.6080306@sssup.it>
In-Reply-To: <4D23AF8A.6080306@sssup.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/01/2011 00:38, Tommaso Cucinotta ha scritto:
> Of course, don't misunderstand me: this is a necessary condition for a
> stable performance of KVM VMs, I'm not saying it is sufficient for
>
... it.

Please, comment on this (reply to all, please, I'm not following LKML).

Thanks,

     Tommaso
