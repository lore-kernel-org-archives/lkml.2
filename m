Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2ATO7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:59:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab2ATO7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:59:18 -0500
Date: Fri, 20 Jan 2012 15:59:07 +0100
From: Karel Zak <kzak@redhat.com>
To: Attila Kinali <attila@kinali.ch>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
Message-ID: <20120120145907.GA20377@x2.net.home>
References: <20120120140444.GC13157@x2.net.home>
 <20120120154309.3ae5f9e4a8f55c477dc423ab@kinali.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120154309.3ae5f9e4a8f55c477dc423ab@kinali.ch>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 03:43:09PM +0100, Attila Kinali wrote:
> Hence, i would like to ask you to consider not adding /etc/fstab.d
> unless there is a very good reason to do it. And "to make it simpler
> for people who have a lot of mountpoints" is IMHO not a good reason.
> How many mountpoints must one use that a single file becomes a problem?

 Let's imagine that you have a network and you use the same configuration
 on all machines, then "*.d/" directories are very useful for you -- for
 example you can create a company.rpm with important configuration and
 distribute it to all machines.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
