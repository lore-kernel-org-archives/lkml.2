Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab1JTPdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:33:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:38292 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab1JTPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:33:48 -0400
Date: Fri, 21 Oct 2011 02:33:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Zhou Peng <ailvpeng25@gmail.com>
cc: Casey Schaufler <casey@schaufler-ca.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] ACL supports to mqueue
In-Reply-To: <CAH-7YMmqs9j2-UTUSCZaFDEhxmjkAZvHzKVvbvy7nsG8JpFA9w@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1110210232450.31056@tundra.namei.org>
References: <CAH-7YMmqs9j2-UTUSCZaFDEhxmjkAZvHzKVvbvy7nsG8JpFA9w@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Oct 2011, Zhou Peng wrote:

> This patch adds ACL supports to mqueue filesystem.
> Based on Linux 3.0.4.

Why is this necessary, and who is planning to use it?

Are any distros likely to enable this?


- James
-- 
James Morris
<jmorris@namei.org>
