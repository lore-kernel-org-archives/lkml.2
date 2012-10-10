Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2JJWex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:34:53 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:38181 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab2JJWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:34:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Richard Weinberger <richard@nod.at>
X-Fcc: ~/Mail/lkml
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Oleg Nesterov <oleg@redhat.com>, Amerigo Wang <amwang@redhat.com>,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        Pedro Alves <palves@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] Include asm/siginfo.h in linux/coredump.h
In-Reply-To: Richard Weinberger's message of  Thursday, 11 October 2012 00:20:56 +0200 <20121011002056.09c7c2bb@spider.haslach.nod.at>
References: <1349906647-26042-1-git-send-email-richard@nod.at>
	<20121010151659.029b2a46.akpm@linux-foundation.org>
	<20121011002056.09c7c2bb@spider.haslach.nod.at>
X-Zippy-Says: I'm a GENIUS!  I want to dispute sentence structure with SUSAN SONTAG!!
Message-Id: <20121010223448.94A1B2C0B1@topped-with-meat.com>
Date: Wed, 10 Oct 2012 15:34:48 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=LtfpOghc c=1 sm=1 a=ieMP1_nGAVIA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=14OXPxybAAAA:8
		a=FvDs8Y8mmgcA:10 a=vO3cfOOO98xVD0SWvIkA:9 a=CjuIK1q_8ugA:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are other cases that just forward declare 'struct siginfo' and use it
instead of the typedef names (e.g. linux/sched.h).
