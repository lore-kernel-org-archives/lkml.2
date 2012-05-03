Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab2ECL6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:58:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61225 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310Ab2ECL6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:58:08 -0400
Message-ID: <4FA272CD.90808@cantab.net>
Date: Thu, 03 May 2012 12:58:05 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 8/8] xen/setup: Combine the two hypercall
 functions - since they are quite similar.
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com> <1334596539-18172-9-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1334596539-18172-9-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/12 18:15, Konrad Rzeszutek Wilk wrote:
> They use the same set of arguments, so it is just the matter
> of using the proper hypercall.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: David Vrabel <david.vrabel@citrix.com>

But would it be better to fold this into the previous patch?

David
