Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0IOQ6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:58:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41853 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0IOQ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jyvkmP8nJv0reaT5nINnrEGyMxN0WKs7eogs2YCZ+YDkpJUW1kQBiU7xQQz+NEcqPs
         C7TD8p+tdeHOBFdfSrwWFagdH9L5iJrKpGKEENd7xOn73Ooqv5GCz04UhOdUSBhl98Qg
         9WY4XYP8FFhocytXsHMyKq5ud9ackobLvM/B4=
Date: Wed, 15 Sep 2010 09:57:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Keng-Yu Lin <keng-yu.lin@canonical.com>
Cc: len.brown@intel.com, alan-jenkins@tuffmail.co.uk, superm1@ubuntu.com,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: Add debugfs support
Message-ID: <20100915165755.GA29234@core.coreip.homeip.net>
References: <1284457690-32635-1-git-send-email-keng-yu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284457690-32635-1-git-send-email-keng-yu.lin@canonical.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keng-Yu,

On Tue, Sep 14, 2010 at 05:48:10PM +0800, Keng-Yu Lin wrote:
> Export the status of RF killswitch through debugfs.
> 

The patch description could be improved. What is the driving point in
exporting this data?

Thanks.

-- 
Dmitry
