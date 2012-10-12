Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab2JLUQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:16:38 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:44765
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab2JLUQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:16:37 -0400
Message-ID: <1350072695.7065.71.camel@rhapsody>
Subject: Re: [PATCH 2/5] efivarfs: efivarfs_create() ensure we drop our
 reference on inode on error
From: Khalid Aziz <khalid@gonehiking.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Oct 2012 14:11:35 -0600
In-Reply-To: <1350069693.15966.591.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1349416496.810727.310563927016.1.gpush@pecola>
	 <1349951541-20498-1-git-send-email-apw@canonical.com>
	 <1349951541-20498-3-git-send-email-apw@canonical.com>
	 <1350068629.7065.58.camel@rhapsody>
	 <1350069693.15966.591.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 20:21 +0100, Matt Fleming wrote:
> This is a common idiom used throughout the kernel to simply error paths.
> As you noted, calling kfree(NULL) is harmless and there's certainly no
> need to worry about the overhead of calling kfree() without doing any
> freeing since the error path is also the slow path.

A "return -ENOMEM" looks simpler and easier to read to me, but that is a
subjective opinion :)

--
Khalid

