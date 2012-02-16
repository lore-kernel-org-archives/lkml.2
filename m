Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2BPQYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:24:49 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52787 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136Ab2BPQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:24:47 -0500
X-Sasl-enc: dqO72IGByHFy17pBg1Ho6XJd+u7BfMVwRkoliV/CLTio 1329409485
Date: Thu, 16 Feb 2012 08:24:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] sysfs: Push file_update_time() into
 bin_page_mkwrite()
Message-ID: <20120216162426.GC20827@kroah.com>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
 <1329399979-3647-10-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329399979-3647-10-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 02:46:17PM +0100, Jan Kara wrote:
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

