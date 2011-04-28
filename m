Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366Ab1D1OFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 10:05:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45083 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1D1OE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 10:04:59 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Colin Ian King <colin.king@ubuntu.com>
Cc: James Bottomley <james.bottomley@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback related.
In-reply-to: <1303999282.2081.15.camel@lenovo>
References: <1303920553.2583.7.camel@mulgrave.site> <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site> <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site> <1303925374-sup-7968@think> <1303926637.2583.17.camel@mulgrave.site> <1303934716.2583.22.camel@mulgrave.site> <1303990590.2081.9.camel@lenovo> <1303993705-sup-5213@think> <1303998140.2081.11.camel@lenovo> <1303998300-sup-4941@think> <1303999282.2081.15.camel@lenovo>
Date: Thu, 28 Apr 2011 10:04:34 -0400
Message-Id: <1303999415-sup-362@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DB97405.00CB:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Colin Ian King's message of 2011-04-28 10:01:22 -0400:
> 
> > Could you post the soft lockups you're seeing?
> 
> As requested, attached

These are not good, but they aren't the lockup James was seeing.  Were
these messages with my patch?  If yes, please post the messages from
without my patch.

-chris
