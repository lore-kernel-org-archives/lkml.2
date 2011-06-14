Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1FNWPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:15:20 -0400
Received: from outmail011.snc4.facebook.com ([66.220.144.143]:59611 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529Ab1FNWPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:15:18 -0400
Date: Tue, 14 Jun 2011 15:15:17 -0700
From: Arun Sharma <asharma@fb.com>
To: Sam Liao <phyomh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
Message-ID: <20110614221517.GA20319@dev1756.snc6.facebook.com>
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
 <20110609193300.GA16858@dev1756.snc6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609193300.GA16858@dev1756.snc6.facebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

$ perf report -g graph,0.5,caller --sort pid

is a bit hard to type. Perhaps add a simpler command line option
that has the same effect?

 -Arun

