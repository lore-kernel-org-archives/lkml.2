Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2GZXuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 19:50:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45365 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2GZXt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 19:49:59 -0400
Date: Thu, 26 Jul 2012 16:49:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com, vm-crosstalk@vmware.com, cschamp@vmware.com
Subject: Re: [vmw_vmci 07/11] Apply VMCI hash table
Message-ID: <20120726234954.GC3849@kroah.com>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
 <1343345980-32397-8-git-send-email-astiegmann@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343345980-32397-8-git-send-email-astiegmann@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 04:39:36PM -0700, Andrew Stiegmann (stieg) wrote:
> Implements a hash table for VMCI's use.

What's wrong with the in-kernel hash table(s)?

