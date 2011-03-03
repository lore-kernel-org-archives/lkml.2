Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab1CCSaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:30:03 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:62607 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1CCS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:29:59 -0500
Subject: Re: [PATCH] Make /proc/slabinfo 0400
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1299176266.8493.2369.camel@nimitz>
References: <1299174652.2071.12.camel@dan>
	 <1299176266.8493.2369.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 13:29:55 -0500
Message-ID: <1299176995.2071.15.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Please don't.  In reality, it'll just mean that more data collection
> things will have to get done as root, and I'll wear my keyboard out more
> often sudo'ing.
> 
> If you really want this on particularly pedantic systems, why not chmod?
> 

I believe the vast majority of users do not need the ability to read
this file from an unprivileged login.  We should strive for security by
default.  As you said, you can simply chmod this file to regain the
access permissions you require for your less common use case.

> -- Dave


