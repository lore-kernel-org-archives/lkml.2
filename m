Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0EXL5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 07:57:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755390Ab0EXL5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 07:57:45 -0400
Date: Mon, 24 May 2010 12:57:37 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with
	name_to_dev_t
Message-ID: <20100524115737.GY3991@agk-dp.fab.redhat.com>
Mail-Followup-To: Will Drewry <wad@chromium.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, snitzer@redhat.com
References: <1274294304-30606-1-git-send-email-wad@chromium.org> <1274294304-30606-3-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274294304-30606-3-git-send-email-wad@chromium.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 01:38:24PM -0500, Will Drewry wrote:
> +	char base_path[32];  /* size from name_to_dev_t */
  
> +	/* stage the shorter path for name_to_dev_t. */
> +	strncpy(base_path, path, sizeof(base_path));

I'm dropping that, and just passing path directly, so the strlen test
will be used.  (There's a "name += 5" in there so 32 would ignore
any longer standard names anyway.)

Alasdair

