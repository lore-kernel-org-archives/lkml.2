Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1FJNUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:20:45 -0400
Received: from defer-dn03.ocn.ad.jp ([125.170.100.156]:60985 "EHLO
	defer-dn03.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab1FJNUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:20:42 -0400
Date: Fri, 10 Jun 2011 22:19:01 +0900 (JST)
Message-Id: <20110610.221901.193681450.anemo@mba.ocn.ne.jp>
To: viresh.kumar@st.com
Cc: dan.j.williams@intel.com, linus.walleij@linaro.org, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, shiraz.hashim@st.com,
        armando.visconti@st.com, bhupesh.sharma@st.com,
        linux-raid@vger.kernel.org
Subject: Re: Why move all map_sg/unmap_sg for slave channel to its client?
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4DF19251.1090100@st.com>
References: <BANLkTik9kZjJs5H2kvM+xAtd_CR5NA0dDw@mail.gmail.com>
	<BANLkTikzDEx2netonGyhskYFtiAEAxq5XQ@mail.gmail.com>
	<4DF19251.1090100@st.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 09:11:05 +0530, viresh kumar <viresh.kumar@st.com> wrote:
> >>> I thought map_sg/unmap_sg for slave channels will be handled according
> >>> to the flags passed in prep_slave_sg(). But then i found following patch:
...
> Linus, Dan,
> 
> Got it. Thanks for your replies.

JFYI, the old discussion was here:

https://lkml.org/lkml/2009/7/24/114

---
Atsushi Nemoto
