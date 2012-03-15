Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031674Ab2COSDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:03:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44821 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab2COSDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:03:16 -0400
Date: Thu, 15 Mar 2012 11:03:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Liz Clark <liz.clark@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Wrong unicode value copied in con_set_unimap()
Message-ID: <20120315180312.GC26442@kroah.com>
References: <1331832809-4484-1-git-send-email-liz.clark@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331832809-4484-1-git-send-email-liz.clark@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:33:29AM -0700, Liz Clark wrote:
> Bugzilla 40012: PIO_UNIMAP bug: error updating Unicode-to-font map

What bugzilla are you referring to here?  bugs.gentoo.org?  :)

