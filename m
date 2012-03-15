Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031367Ab2COB1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:27:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:32463 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030342Ab2COB1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:27:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119079760"
Subject: Re: [PATCH v2] libata: disable runtime pm for hotpluggable port
From: Lin Ming <ming.m.lin@intel.com>
To: Matt <jackdachef@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, jslaby@suse.cz, cwillu@cwillu.com,
        Sergei Shtylyov <sshtylyov@mvista.com>
In-Reply-To: <CAG-aW06hebVsVrFZvTMMuS6v6VNGf65H8h1X3eMaNXZo_QmbBQ@mail.gmail.com>
References: <1331603857.3436.24.camel@minggr>
	 <CAG-aW06hebVsVrFZvTMMuS6v6VNGf65H8h1X3eMaNXZo_QmbBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 09:27:37 +0800
Message-ID: <1331774857.3436.26.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 23:49 +0100, Matt wrote:
[...]
> 
> Hi Lin Ming,
> 
> thanks for CCing on the updated patch
> 
> I just finished testing it with 3.3-rc7 and it works as advertised

Thanks a lot for the test :)

> 
> 
> Kind Regards
> 
> Matt


