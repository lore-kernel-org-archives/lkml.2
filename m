Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab1DYSME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 14:12:04 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61812 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab1DYSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 14:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=MjTEIXfGjQZUH5ZRGl4xvlPAbppXzvj6+H9LQ63/Ce/jAGDNYqP9TgQrgCKnQE4lxm
         CKsWUdY0acpamf1ulCAsQdemPBhnWKIf1VKFNS7sJeeHNvK+HIthr7zdRzmRqoYBCIcg
         JSwIeuzYdGV21QWQ3gjUjn6UVEaRUv1ji5PQA=
MIME-Version: 1.0
In-Reply-To: <20110425182906.2673.A69D9226@jp.fujitsu.com>
References: <20110425182906.2673.A69D9226@jp.fujitsu.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 25 Apr 2011 14:11:35 -0400
Message-ID: <BANLkTinNhM5GwOKdS4hX==Wk71bTe-t4-w@mail.gmail.com>
Subject: Re: [PATCH 0/4] blackfin: convet cpumask apis
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        device-driver-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 05:27, KOSAKI Motohiro wrote:
> Rusty Russle introduced a lot of cpumask related APIs. and He gone even
> though the work is unfinished. This patch series is sequel of his work.
>
> No functional change. only api change.
>
> note: I've confirmed only cross-compile build. so, I hope blackfin
> developers see the code.

fyi, device-driver-devel@b.u.o is for general device drivers while
uclinux-dist-devel@b.u.o is for Blackfin arch work
-mike
