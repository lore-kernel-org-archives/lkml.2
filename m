Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1BHLYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 06:24:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43118 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1BHLYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 06:24:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cNjT2z8gUVFggvlJv7Dbaci2A2KAr9lruCHP6wHVDyVve0LDOT+FPVSLJx1BKrI7kU
         kWmUQb/ON5pwC9PGVZyHJcgMjtGIlc07I/ddNo4W0yvibbgzOQf0/TQY7azeZSrJQ6Ub
         cDDRG2XFDBoLivjLVRQNt9XyQ3Sleaf77ut+8=
Date: Tue, 8 Feb 2011 14:23:54 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, jon.nettleton@gmail.com,
        linux-kernel@vger.kernel.org, dilinger@queued.net, cjb@laptop.org
Subject: Re: [PATCH RFC] staging: olpc_dcon: Remove _strtoul() function.
Message-ID: <20110208112354.GN4384@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, jon.nettleton@gmail.com,
	linux-kernel@vger.kernel.org, dilinger@queued.net, cjb@laptop.org
References: <1297163160-23429-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297163160-23429-1-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 12:06:00PM +0100, Marek Belisko wrote:
> olpc_dcon driver use self invented _strtoul  function
> which make similar check like strict_strtoul just extend
> for space checking at last string place. Normally access
> to sys file looks echo 1024 > /sys/... so space could be considered
> as error character and we could simplify code using just strict_strtoul
> function instead self invented.
> 

Could you do it on top of the patches that Andres Salomon sent?

http://driverdev.linuxdriverproject.org/pipermail/devel/2011-February/thread.html

# [PATCH 1/4] olpc_dcon: get rid of global i2c_client, create a dcon_priv struct   Andres Salomon
# [PATCH 2/4] olpc_dcon: change sysfs 'output' toggle to be clearer...   Andres Salomon
# [PATCH 3/4] olpc_dcon: move more variables into dcon_priv   Andres Salomon
# [PATCH 4/4] olpc_dcon: actually return the value of i2c_add_driver   Andres Salomon 

regards,
dan carpenter


