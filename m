Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2JRVVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab2JRVVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:21:11 -0400
Date: Thu, 18 Oct 2012 17:18:21 -0400
From: Rik van Riel <riel@redhat.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, a.p.zijlstra@chello.nl
Subject: [PATCH 0/2] minor NUMA cleanups & documentation
Message-ID: <20121018171821.7f1b1683@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are some minor NUMA cleanups to start with.

I have some ideas for larger improvements and ideas to port over
from autonuma, but I got caught up in some of the code and am
not sure about those changes yet.

-- 
All Rights Reversed
