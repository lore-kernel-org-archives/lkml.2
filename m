Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab2AZOkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:40:19 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51775 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab2AZOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:40:18 -0500
Message-ID: <1327588816.14789.0.camel@lappy>
Subject: Re: [PATCH] netns: fix net_alloc_generic()
From: Sasha Levin <levinsasha928@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, davej@redhat.com, sjurbren@gmail.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>
Date: Thu, 26 Jan 2012 09:40:16 -0500
In-Reply-To: <1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <CA+1xoqe+Qa1OByj7z7XzAPG_g9+BmNj9NPZR=_5b_MTEmc9Chw@mail.gmail.com>
	 <1327523631-3480-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 11:41 +0100, Eric Dumazet wrote:
> Could you test following patch instead ?

Works for me.

-- 

Sasha.

