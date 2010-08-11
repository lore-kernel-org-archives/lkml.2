Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab0HKKtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 06:49:11 -0400
Received: from ozlabs.org ([203.10.76.45]:57567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0HKKtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 06:49:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH 1/2] param: allow omitting set() methods for truly read-only params
Date: Wed, 11 Aug 2010 20:19:01 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <1281466725-22549-1-git-send-email-dtor@vmware.com> <201008111109.30433.rusty@rustcorp.com.au> <6889404B-C389-4421-BDD7-A042DAAB064A@vmware.com>
In-Reply-To: <6889404B-C389-4421-BDD7-A042DAAB064A@vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008112019.03089.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 05:05:51 pm Dmitry Torokhov wrote:
> On Aug 10, 2010, at 6:39 PM, "Rusty Russell" <rusty@rustcorp.com.au> wrote:
> > On Wed, 11 Aug 2010 04:28:44 am Dmitry Torokhov wrote:
> >> Certain "parameters", such as acpica version and upcoming VMware  
> >> Balloon version, are need to be purely read-only. 
> >
> > Your followup patch uses this for version, but the version is already
> > in /sys/module/vmware_balloon/version as is standard with modules, no?
> 
> That version attribute is not present if the driver is built-in, only  
> parameters are visible in both cases.

You know what I'm going to say now then, don't you? :)

Thanks,
Rusty.
