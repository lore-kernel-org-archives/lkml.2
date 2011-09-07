Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1IGBIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:08:37 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64062 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1IGBI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <1315276556-10970-1-git-send-email-glommer@parallels.com>
References: <1315276556-10970-1-git-send-email-glommer@parallels.com>
From: Paul Menage <paul@paulmenage.org>
Date: Tue, 6 Sep 2011 18:08:08 -0700
X-Google-Sender-Auth: tUx05-flwkqtFsbO6eWnI4nBVEU
Message-ID: <CALdu-PDoPPdcX0bAkVpaP9R-z1yKin=JOjjT3rMuoSHJaywSCg@mail.gmail.com>
Subject: Re: [PATCH] per-cgroup tcp buffer limitation
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, netdev@vger.kernel.org, xemul@parallels.com,
        "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 5, 2011 at 7:35 PM, Glauber Costa <glommer@parallels.com> wrote:
> This patch introduces per-cgroup tcp buffers limitation. This allows
> sysadmins to specify a maximum amount of kernel memory that
> tcp connections can use at any point in time. TCP is the main interest
> in this work, but extending it to other protocols would be easy.

The general idea of limiting total socket buffer memory consumed by a
cgroup is a fine idea, but I think it needs to be integrated more
closely with the existing kernel memory cgroup tracking efforts,
especially if you're trying to use as generic a name as "kmem" for it.

I agree with Kamezawa's comments that you need a lot more documentation.

Paul
