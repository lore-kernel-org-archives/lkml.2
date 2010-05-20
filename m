Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab0ETSOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:14:18 -0400
Received: from claw.goop.org ([74.207.240.146]:35507 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0ETSOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:14:16 -0400
Message-ID: <4BF57BF6.9000208@goop.org>
Date: Thu, 20 May 2010 11:14:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Shriram Rajagopalan <rshriram@gmail.com>
CC: Ian Campbell <ian.campbell@citrix.com>, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: ensure timer tick is resumed even on
 CPU 	driving the resume
References: <1274283134.14939.205.camel@zakaz.uk.xensource.com>	 <1274283417-5224-1-git-send-email-ian.campbell@citrix.com>	 <4BF427AB.4080301@goop.org> <AANLkTimc7ErLqUi4VKRztjAi6TNrv0Ooarc20OjFolkc@mail.gmail.com>
In-Reply-To: <AANLkTimc7ErLqUi4VKRztjAi6TNrv0Ooarc20OjFolkc@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 10:42 AM, Shriram Rajagopalan wrote:
> I know this is a long shot but is there an equivalent piece of code in
> the 2.6.18.8-xen kernel where this patch could be applied ? Assuming
> that the 2.6.18 also has a similar bug.

Very unlikely.  Time is completely different in 2.6.18-xen.

    J
