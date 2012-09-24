Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2IXJd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:33:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51609 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2IXJdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:33:25 -0400
Date: Mon, 24 Sep 2012 12:33:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: hot-added cpu is not asiggned to the correct node
Message-ID: <20120924093312.GC28937@mwanda>
References: <50501E97.2020200@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50501E97.2020200@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:33:11PM +0900, Yasuaki Ishimatsu wrote:
> When I hot-added CPUs and memories simultaneously using container driver,
> all the hot-added CPUs were mistakenly assigned to node0.
> 

Is this something which used to work correctly?  If so which was the
most recent working kernel?

regards,
dan carpenter
