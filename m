Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1KYXem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 18:34:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38502 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1KYXel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 18:34:41 -0500
Date: Sat, 26 Nov 2011 03:34:36 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: =?utf-8?B?7LWc7KKF7ZmY?= <jhbird.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] max8997_charger: Remove duplicate module.h
Message-ID: <20111125233436.GA19161@oksana.dev.rtsoft.ru>
References: <16505126.116361322047601084.JavaMail.weblogic@epml27>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16505126.116361322047601084.JavaMail.weblogic@epml27>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:26:41AM +0000, MyungJoo Ham wrote:
> Sender : 최종환<jhbird.choi@samsung.com> S4(선임)/선임/S/W Solution개발팀(S.LSI)/삼성전자
> Date : 2011-11-23 13:40 (GMT+09:00)
> Title : [PATCH] max8997_charger: Remove duplicate module.h
> > 
> > From: Jonghwan Choi <jhbird.choi@samsung.com>
> > 
> > module.h was included twice.
> > 
> > Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> 
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

The issue introduced in post-3.1 kernels, and since I don't want
to send it to Linus now (as it is not a regression fix), nor I want
to pull -rc kernels into battery GIT tree, I'll just let the patch
sit for awhile till 3.2 released. And during merge window I'll apply
it, just before sending pull request.

That is, I noticed the patch, it looks OK, and I'll apply it. Just
not now.

Thanks!

p.s.
The other option you have is to send the patch via -trivial tree.
I'm fine either way.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
