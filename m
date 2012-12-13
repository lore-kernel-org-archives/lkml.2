Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab2LMQWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:22:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49722 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab2LMQWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:22:10 -0500
Date: Thu, 13 Dec 2012 16:22:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: tux2002@front.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] subsystem: proc filesystem
Message-ID: <20121213162207.GP4939@ZenIV.linux.org.uk>
References: <fd65ffe19c664aff3266d7082240abdd3d1efc54@mail.qip.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd65ffe19c664aff3266d7082240abdd3d1efc54@mail.qip.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 05:15:44PM +0400, tux2002@front.ru wrote:
> 
> 
> This patch strengthens file permissions of pid record in proc filesystem. When pid and pidentry records created, his permissions strengthens by creator umask.
> 

NAK.  "Creator" in this case means "whoever had done lookup first".
