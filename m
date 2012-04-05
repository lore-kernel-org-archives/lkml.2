Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2DESHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 14:07:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2DESHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 14:07:02 -0400
Date: Thu, 5 Apr 2012 14:06:14 -0400
From: Andy Gospodarek <gospo@redhat.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: netdev@vger.kernel.org, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] bonding: properly unset current_arp_slave on slave
 link up
Message-ID: <20120405180614.GB11165@quad.redhat.com>
References: <20120405134743.GB16870@darkmag.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405134743.GB16870@darkmag.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 03:47:43PM +0200, Veaceslav Falico wrote:
> When a slave comes up, we're unsetting the current_arp_slave without
> removing active flags from it, which can lead to situations where we have
> more than one slave with active flags in active-backup mode.
> 
> To avoid this situation we must remove the active flags from a slave before
> removing it as a current_arp_slave.
> 
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
> 

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>

