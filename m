Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1ISE3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 00:29:53 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:38794 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1ISE3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 00:29:52 -0400
Subject: Re: [PATCH]: Improve performance of LZO hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
Date: Mon, 19 Sep 2011 14:29:51 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316406591.2026.19.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 14:14 +1000, Bojan Smojver wrote:
> +       size_t ring = 0, pg = 0, npages,
> +              have = 0, want = MAP_PAGE_ENTRIES, need, asked = 0; 

The want = MAP_PAGE_ENTRIES part is a bug for sure (a leftover from the
previous version of the patch). The value of want should be set to
npages, once npages is set after the page allocation loop, of course.

-- 
Bojan

