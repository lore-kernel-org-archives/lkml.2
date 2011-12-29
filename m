Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1L2QfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:35:12 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38377 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab1L2QfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:35:09 -0500
MIME-Version: 1.0
Message-ID: <26caec11-5ecc-48da-853b-53aa44a5f30a@default>
Date: Thu, 29 Dec 2011 08:34:47 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: RE: [PATCH] staging: zcache: add crypto API support
References: <<1325082113-2843-1-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1325082113-2843-1-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4EFC96B4.00DF,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Wednesday, December 28, 2011 7:22 AM
> To: Greg Kroah-Hartman
> Cc: Seth Jennings; Dan Magenheimer; Nitin Gupta; Dave Hansen; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org; Thadeu Lima de Souza Cascardo; Brian King; Robert Jennings
> Subject: [PATCH] staging: zcache: add crypto API support
> 
> This patch allow zcache to use the crypto API for page compression.
> It replaces the direct LZO compress/decompress calls with calls
> into the crypto compression API. The compressor to be used is
> specified in the kernel boot line with the zcache parameter like:
> zcache=lzo or zcache=deflate.  If the specified compressor can't
> be loaded, zcache uses lzo as the default compressor.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
