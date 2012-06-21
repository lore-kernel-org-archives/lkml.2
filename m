Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520Ab2FUWrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:47:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54408 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759188Ab2FUWrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:47:42 -0400
Date: Thu, 21 Jun 2012 15:47:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, apw@canonical.com
Subject: Re: [PATCH 00/13] drivers: hv: kvp
Message-ID: <20120621224737.GA5933@kroah.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340314200-27078-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 02:30:00PM -0700, K. Y. Srinivasan wrote:
> This patchset expands the KVP (Key Value Pair) functionality to
> implement the mechanism to get/set IP addresses in the guest. This
> functionality is used in Windows Server 2012 to implement VM
> replication functionality. The way IP configuration information
> is managed is distro specific. The current implementation supports
> RedHat way of doing things. We will expand support to other distros
> incrementally. 

I'm missing 09/13, did it get stuck somewhere?
