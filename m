Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2EaHn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:43:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34076 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2EaHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205301430001.9716@chino.kir.corp.google.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
	<CAHGf_=p7JbWW8jgzWGHX+xwU8JWzpSMZS0kn-rmP=eg_Uqrgow@mail.gmail.com>
	<alpine.DEB.2.00.1205082158570.10766@chino.kir.corp.google.com>
	<alpine.LFD.2.02.1205300947180.2681@tux.localdomain>
	<alpine.DEB.2.00.1205301040170.29257@router.home>
	<20120530163246.GF9850@tassilo.jf.intel.com>
	<alpine.DEB.2.00.1205301430001.9716@chino.kir.corp.google.com>
Date: Thu, 31 May 2012 10:43:25 +0300
X-Google-Sender-Auth: U_inrVThYb4kyUfCbwOXZ5HrmCo
Message-ID: <CAOJsxLF5vTnCO5fxcwZs0_r32VrK3Tb9k0Sk1sRuH-+Dd48dPw@mail.gmail.com>
Subject: Re: [PATCH] slab/mempolicy: always use local policy from interrupt
 context v3
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 12:30 AM, David Rientjes <rientjes@google.com> wrote:
> Any idea why this isn't in today's linux-next if it was fixed in another
> thread?

I didn't seen the fixed one either which is why I haven't picked it up.
