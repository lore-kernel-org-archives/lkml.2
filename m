Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab1BNDwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 22:52:44 -0500
Received: from ozlabs.org ([203.10.76.45]:52450 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab1BNDwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 22:52:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Imran Haider <imran1008@gmail.com>
Subject: Re: [PATCH] module: Fix bug: read __param section as pointers to object
Date: Mon, 14 Feb 2011 09:39:09 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <1297614554-24373-1-git-send-email-imran1008@gmail.com>
In-Reply-To: <1297614554-24373-1-git-send-email-imran1008@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102140939.09897.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 02:59:14 am Imran Haider wrote:
> Recent changes in commit 3834583b causes module parameters to be stored
> in the __param section as pointer to struct instead of the struct itself.
> module.c was still reading the section as an array of struct which caused
> modules to not load when any module parameter is specified.

This is linux-next?

Yes, completely broken.  I've removed the patch.

Thanks,
Rusty.
