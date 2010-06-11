Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0FKXI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:08:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823Ab0FKXI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:08:28 -0400
MIME-Version: 1.0
In-Reply-To: <20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
References: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
	<20100611224902.5039.60134.stgit@bumblebee1.mtv.corp.google.com>
Date: Fri, 11 Jun 2010 16:07:54 -0700
Message-ID: <AANLkTikc7pxhd9tGI1ADsTBTc8CYeOHtXzTpSKk5bxh-@mail.gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be 
	reused immediately.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Salman <sqazi@google.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tytso@google.com, walken@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yup. Much prettier. Thanks.

Ingo, Andrew, you can now have a cage-match on who actually takes it.

                      Linus
