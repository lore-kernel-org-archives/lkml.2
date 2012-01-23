Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2AWTi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:38:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57372 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2AWTiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:38:25 -0500
Date: Mon, 23 Jan 2012 11:38:08 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Transparent huge pages and shmem?
In-Reply-To: <CB1B361E45A85849902B25342E88900501F504CDD753@ABGEX70E.FSC.NET>
Message-ID: <alpine.LSU.2.00.1201231132030.1677@eggly.anvils>
References: <CB1B361E45A85849902B25342E88900501F504CDD753@ABGEX70E.FSC.NET>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012, Borzenkov, Andrey wrote:

> In case of THP enabled kernel - will THP be used for SysV shmem?
> The obvious target is to avoid pre-allocation of huge pages pool
> for databases like Oracle that is required today.

It will one day, yes.  Various people are very interested in THP on
tmpfs/shmem, which serves SysV shm.  But at present THP is limited to
private anonymous pages, and its extension to shared file pages is not
trivial.  I have not heard of anyone making significant progress on
that as yet - but perhaps someone is working on it behind the scenes.

Hugh
