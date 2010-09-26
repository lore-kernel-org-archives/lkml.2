Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab0IZNIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 09:08:36 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:40068 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab0IZNIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 09:08:35 -0400
Date: Sun, 26 Sep 2010 14:08:33 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: James <bjlockie@lockie.ca>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: no modules :-)
Message-ID: <20100926130833.GB30683@sucs.org>
References: <4C9D845A.4060105@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C9D845A.4060105@lockie.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 01:10:50AM -0400, James wrote:
>  I don't like modules. :-)
> 
> What is pulling this in:
> 
> CONFIG_SCSI_WAIT_SCAN=m

Disable modules and it will disappear. I believe it is related to
CONFIG_SCSI_SCAN_ASYNC but take a look at commit
5e2fb917920c62c5ad260962471aeb578b52ac40 for some more details too...

-- 
Sitsofe | http://sucs.org/~sits/
