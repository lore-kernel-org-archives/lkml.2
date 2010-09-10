Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab0IJGM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 02:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab0IJGM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 02:12:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] exec: don't turn PF_KTHREAD off when command not found
In-Reply-To: KOSAKI Motohiro's message of  Thursday, 9 September 2010 18:03:30 +0900 <20100909180236.C94C.A69D9226@jp.fujitsu.com>
References: <20100909180236.C94C.A69D9226@jp.fujitsu.com>
X-Shopping-List: (1) Missing sunburnt invasions
   (2) Lucky colliders
   (3) Porous complicators
   (4) Spherical piano ignorers
   (5) Persistent accusers
Message-Id: <20100910061255.6C09844197@magilla.sf.frob.com>
Date: Thu,  9 Sep 2010 23:12:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That looks reasonable to me too.


Thanks,
Roland
