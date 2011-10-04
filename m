Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1JDIlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 04:41:10 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:36236 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab1JDIlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 04:41:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E8AC89C.7010409@cam.ac.uk>
Date: Tue, 04 Oct 2011 09:49:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110930 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
References: <20111004190542.3ae8a2d575b936520ad36c52@canb.auug.org.au>
In-Reply-To: <20111004190542.3ae8a2d575b936520ad36c52@canb.auug.org.au>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/11 09:05, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/staging/iio/industrialio-buffer.c: In function 'iio_show_fixed_type':
> drivers/staging/iio/industrialio-buffer.c:108:7: error: '__LITTLE_ENDIAN' undeclared (first use in this function)
> 
> Caused by commit 8310b86c3cd2 ("staging:iio:scan element types: introduce
> endian description to the data format") from the staging tree.  Missing
> include file ...
> 
> I haven't bothered fixing this for today.
gah.  Sorry about that one.  Clearly should be an ifdef not an if.  Will send patch shortly.

