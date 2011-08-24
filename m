Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1HXSry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:47:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab1HXSrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:47:53 -0400
Date: Wed, 24 Aug 2011 11:47:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: <ryan@bluewatersys.com>, <haojian.zhuang@marvell.com>,
        <johnpol@2ka.mipt.ru>, <simon.inizan@goobie.fr>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] w1: ds2780, fix deadlock upon insertion and
 removal
Message-Id: <20110824114703.e82021ec.akpm@linux-foundation.org>
In-Reply-To: <4E550C35.4080700@indesign-llc.com>
References: <4E550C35.4080700@indesign-llc.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 10:35:33 -0400
Clifton Barnes <cabarnes@indesign-llc.com> wrote:

> Fixes the deadlock when inserting and removing the ds2780.

When fixing a bug, please always provide a full description of that bug
so that others can review the proposed fix.  "the deadlock" is not a
complete description ;)

