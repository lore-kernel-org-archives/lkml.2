Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab0KPHxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:53:21 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59835 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433Ab0KPHxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:53:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qYQt0vUy9bDu9KP4eVwjrG7kqxIYvQzGC7bKhFngT7kUg2IPnSFsFU/Z/CW9G/w9Sc
         OxRxDuDWxBbzEGmmLPZs3/eMfeZxPxN8roxmn7NTXuEq3W+cTocDfXQEgy6zLzKF1Xzx
         M2bIrpP3a0etRqrwg/2UFQ0ex00u2Ztr83BwE=
MIME-Version: 1.0
In-Reply-To: <20101116074717.GB3460@amd>
References: <20101109123246.GA11477@amd>
	<20101114182614.BEE5.A69D9226@jp.fujitsu.com>
	<20101115092452.BEF1.A69D9226@jp.fujitsu.com>
	<20101116074717.GB3460@amd>
Date: Tue, 16 Nov 2010 09:53:19 +0200
Message-ID: <AANLkTi=BhuVn8F3ioTyR8S=J3LfJbuhYsMoHf9f=bvRn@mail.gmail.com>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick, I want to test your tree.
This is taking too long.
Make something available now. And test it in real configs.
