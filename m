Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1L2RUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:20:14 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48153 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1L2RUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:20:11 -0500
Message-ID: <4EFCA147.50206@vflare.org>
Date: Thu, 29 Dec 2011 12:20:07 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] staging: zcache: add crypto API support
References: <1325082113-2843-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1325082113-2843-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 09:21 AM, Seth Jennings wrote:

> This patch allow zcache to use the crypto API for page compression.
> It replaces the direct LZO compress/decompress calls with calls
> into the crypto compression API. The compressor to be used is
> specified in the kernel boot line with the zcache parameter like:
> zcache=lzo or zcache=deflate.  If the specified compressor can't
> be loaded, zcache uses lzo as the default compressor.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>



Acked-by: Nitin Gupta <ngupta@vflare.org>

Thanks,
Nitin
