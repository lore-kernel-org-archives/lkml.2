Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab2BIBNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:13:50 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48541 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab2BIBNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:13:42 -0500
Date: Wed, 8 Feb 2012 17:13:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 3/5] staging: zcache: replace xvmalloc with zsmalloc
Message-ID: <20120209011326.GA2225@kroah.com>
References: <1326149520-31720-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1326149520-31720-4-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326149520-31720-4-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 04:51:58PM -0600, Seth Jennings wrote:
> Replaces xvmalloc with zsmalloc as the persistent memory allocator
> for zcache
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

This patch no longer applies :(

