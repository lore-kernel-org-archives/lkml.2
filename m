Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2GQOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:09:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43271 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2GQOJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <3e2231e9bf466549d1f9b12359f2f8f6@ozlabs.org>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
	<3e2231e9bf466549d1f9b12359f2f8f6@ozlabs.org>
Date: Tue, 17 Jul 2012 17:09:22 +0300
X-Google-Sender-Auth: Kf3ULHd4JIe1wvJgPtNjlQJNMVg
Message-ID: <CAOJsxLGf6K0G90i==-TJ8WmGvuwtp9mpxsCMSJYw7Wn-JAvpcA@mail.gmail.com>
Subject: Re: [RFC/PATCH] Use kernel supplied MMU info for kvm tool
From: Pekka Enberg <penberg@kernel.org>
To: Matt Evans <matt@ozlabs.org>
Cc: Michael Ellerman <michael@ellerman.id.au>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        prerna@linux.vnet.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 12:33 PM, Matt Evans <matt@ozlabs.org> wrote:
> Just had a look, all good.  Thanks for tidying some old FIXMEs, especially
> the page/segment DT props encoding grot -- and the designated inits in the
> cpuinfo struct, whew, I heard the scream on IRC.  Sorry. ;-)
>
> Acked-by: Matt Evans <matt@ozlabs.org>

Applied, thanks guys!
