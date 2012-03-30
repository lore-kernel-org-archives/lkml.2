Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121Ab2C3TYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:24:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34728 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab2C3TYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:24:07 -0400
Date: Fri, 30 Mar 2012 12:24:02 -0700
From: Greg K H <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
Message-ID: <20120330192402.GA19166@kroah.com>
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com>
 <1333040821-6253-2-git-send-email-mchehab@redhat.com>
 <20120329220300.GA16491@kroah.com>
 <4F74EDEC.5020804@redhat.com>
 <20120329234037.GA16094@kroah.com>
 <4F7516B3.8070505@redhat.com>
 <20120330153152.GD18488@kroah.com>
 <4F75EEB3.2090209@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4F75EEB3.2090209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 02:34:43PM -0300, Mauro Carvalho Chehab wrote:
> Please check if this is the right thing to do. It does the EDAC core changes.
> 
> The real patch is a way more complex than that, as it required to change the 
> struct mem_ctrl_info pointers to an array of array, instead of just an array,
> with means that all drivers need to be changed. This patch is to be applied at
> the end of the patch series.

At first glance, yes, this does look correct, thanks for doing this.

greg k-h
