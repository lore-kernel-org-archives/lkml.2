Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1BKVtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:49:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45118 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1BKVtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:49:03 -0500
Date: Fri, 11 Feb 2011 22:49:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm: add the __noclone attribute
Message-ID: <20110211214900.GC5818@one.firstfloor.org>
References: <4D54D754.4090503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D54D754.4090503@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 02:29:40PM +0800, Lai Jiangshan wrote:
> The changelog of 104f226 said "adds the __noclone attribute",
> but it was missing in its patch. I think it is still needed.

Looks good. Thanks.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
