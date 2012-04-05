Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2DEVla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:41:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47876 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab2DEVl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:41:29 -0400
Date: Thu, 5 Apr 2012 14:41:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Masanari Iida <standby24x7@gmail.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Documentation: mm: Fix path to extfrag_index in
 vm.txt
In-Reply-To: <1333644489-31466-2-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.DEB.2.00.1204051440280.17852@chino.kir.corp.google.com>
References: <1333644489-31466-1-git-send-email-standby24x7@gmail.com> <1333644489-31466-2-git-send-email-standby24x7@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Masanari Iida wrote:

> The path for extfrag_index has not been updated even after it moved
> to under /sys. This patch fixed the path.
> 

The path looks good, but I think it would be better to also add that you 
must mount debugfs for this to be available there.
