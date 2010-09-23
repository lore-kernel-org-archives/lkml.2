Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab0IWEGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 00:06:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51710 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0IWEGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 00:06:34 -0400
X-Authority-Analysis: v=1.1 cv=xllhIT3+0iZermAJQK9ulaVoiSOvD1gApk/LON5m1IU= c=1 sm=0 a=B18Bxh7V_foA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Lu_dWQgaZ_bMRZneHVQA:9 a=FMbSYLqBEtUDfptPFdjcfM06jAwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [GIT PULL] jump label: add jump label code
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20100923034910.867858597@goodmis.org>
References: <20100923034910.867858597@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Sep 2010 00:06:32 -0400
Message-ID: <1285214792.26872.645.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, interesting that the Subject is missing the [PATCH 00/11].

Ah! doing a test, I see that "quilt mail" will not add that, if you
delete the space after "Subject:".  Yes, I develop in git, but send out
patches in quilt. That's just the way I am.

-- Steve


