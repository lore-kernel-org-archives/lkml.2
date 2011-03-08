Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab1CHE0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 23:26:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38319 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab1CHE0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 23:26:05 -0500
Date: Tue, 8 Mar 2011 04:26:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vinay Sawal <vinaysawal@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FC: cifs: Initialized an uninitialized variable
Message-ID: <20110308042601.GX22723@ZenIV.linux.org.uk>
References: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 08:00:09PM -0800, Vinay Sawal wrote:
> Removed a compile time warning by initializing an uninitialized variable.

> -	int rc;
> +	int rc = -EFAULT;

Why is that the right thing to do?  Other than "it made the compiler to
STFU, therefore it is Good(tm)", please.
