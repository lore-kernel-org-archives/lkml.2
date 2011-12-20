Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1LTKRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:17:49 -0500
Received: from casper.infradead.org ([85.118.1.10]:55463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1LTKRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:17:42 -0500
Message-ID: <1324376248.24621.26.camel@twins>
Subject: Re: [PATCH 3/6] perf: add ability to record event period
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: avagin@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        paulus@samba.org, mingo@elte.hu, asharma@fb.com, devel@openvz.org,
        dsahern@gmail.com, linux-perf-users@vger.kernel.org
Date: Tue, 20 Dec 2011 11:17:28 +0100
In-Reply-To: <4EF0424D.3070102@gmail.com>
References: <1323266161-394927-1-git-send-email-avagin@openvz.org>
	 <1323266161-394927-4-git-send-email-avagin@openvz.org>
	 <4EEAEF83.3080100@gmail.com> <20111219205829.GB28058@infradead.org>
	 <4EF0424D.3070102@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 12:07 +0400, Andrew Vagin wrote:
> Look at the comment below. In it I try describe why we need this 
> functionality. 

Its not about comments, a patch has to have a Changelog that covers the
why and what. If it doesn't the patch won't go anywhere. Also, its not
the maintainers job to reconstruct such a changelog from an email
discussion.

So write up a proper changelog and resubmit the patch.
