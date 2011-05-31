Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab1EaW5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:57:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:58977 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab1EaW5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:57:14 -0400
Date: Tue, 31 May 2011 15:57:13 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH] ocfs2: use proper little-endian bitops
Message-ID: <20110531225713.GA10985@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 09:58:05PM +0900, Akinobu Mita wrote:
> Using __test_and_{set,clear}_bit_le() with ignoring its return value
> can be replaced with __{set,clear}_bit_le().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: ocfs2-devel@oss.oracle.com

Looks reasonable to me...

Signed-off-by: Mark Fasheh <mfasheh@suse.com>

Joel?
	--Mark

--
Mark Fasheh
