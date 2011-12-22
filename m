Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1LVLFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:05:43 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42215 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567Ab1LVLFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:05:39 -0500
Message-ID: <1324551934.2153.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] prefetch() not declared in net/ipv4/route.c on s390x
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dan =?ISO-8859-1?Q?Hor=E1k?= <dan@danny.cz>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 22 Dec 2011 12:05:34 +0100
In-Reply-To: <1324551056-28486-1-git-send-email-dan@danny.cz>
References: <1324551056-28486-1-git-send-email-dan@danny.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 22 décembre 2011 à 11:50 +0100, Dan Horák a écrit :
> The recent commit (9f28a2fc0bd77511f649c0a788c7bf9a5fd04edb) to route.c
> breaks build on s390x because it leaves prefetch() undeclared.

Yes, Stephen posted a patch few hours ago.

Thanks


