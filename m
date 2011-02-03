Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1BCKgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:36:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61811 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab1BCKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:36:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=V+8iIRqgBnoRD5mauGdusOC3KNEKD1xcxIHyvybFcAigawducNWXz/DfwxrhH1KYy0
         /2UQIBz36nFzaO8khjK8oaxlyknRtL94dpYJrxAWA4v9PAwqB+0ou6lZ0nicpdlwjB+S
         PyJOMQw9sarBD76FtQC+ly7reXeFjAPpDhgZc=
Date: Thu, 3 Feb 2011 13:35:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: rename_rev.pl script for reviewing renames
Message-ID: <20110203103556.GQ20606@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
	devel@driverdev.osuosl.org
References: <20110203100828.GO20606@bicker>
 <20110203102219.GB6508@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203102219.GB6508@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:22:19AM +0100, Wolfram Sang wrote:
> >     # white space at the end of lines
> >     $line =~ s/ *$//g;
> >     $line =~ s/\t*$//g;
> 
> Character class here as well? Will also get mixtures of the two.
> 

Actually it's better to let diff to take care of white space probably.
I changed the diff at the end to "diff -uw" and it seems to work
beautifully.

regards,
dan carpenter
