Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab0LQPf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:35:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab0LQPfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:35:25 -0500
Date: Fri, 17 Dec 2010 10:34:35 -0500
From: Andy Gospodarek <andy@greyhouse.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Miller <davem@davemloft.net>, Joe Jin <joe.jin@oracle.com>,
        Alexander Indenbaum <baum@tehutinetworks.net>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: [PATCH net-2.6] tehuti: Firmware filename is tehuti/bdx.bin
Message-ID: <20101217153435.GA11221@gospo.rdu.redhat.com>
References: <1292595184.3136.843.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292595184.3136.843.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 02:13:03PM +0000, Ben Hutchings wrote:
> My conversion of tehuti to use request_firmware() was confused about
> the filename of the firmware blob.  Change the driver to match the
> blob.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Thanks for doing that, Ben.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>

