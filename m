Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0LHVQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:16:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9918 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab0LHVQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:16:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dJZPZD6+0I2xfyphUYy1U5GaTdoPWvzicTVI9zIVi4hE/YC6YEzWqNTSjiZB3cqcYm
         zDCAh33MBPJG1atSjFmw==
Date: Wed, 8 Dec 2010 13:16:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric B Munson <emunson@mgebm.net>
cc: Shaohui Zheng <shaohui.zheng@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        dave@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/7,v8] NUMA Hotplug Emulator: documentation
In-Reply-To: <20101208181644.GA2152@mgebm.net>
Message-ID: <alpine.DEB.2.00.1012081315040.15658@chino.kir.corp.google.com>
References: <20101207010033.280301752@intel.com> <20101207010139.681125359@intel.com> <20101207182420.GA2038@mgebm.net> <20101207232000.GA5353@shaohui> <20101208181644.GA2152@mgebm.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Eric B Munson wrote:

> Shaohui,
> 
> I was able to online a cpu to node 0 successfully.  My problem was that I did
> not take the cpu offline before I released it.  Everything looks to be working
> for me.
> 

I think it should fail more gracefully than triggering WARN_ON()s because 
of duplicate sysfs dentries though, right?
