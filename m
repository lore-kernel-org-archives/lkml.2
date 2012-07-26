Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2GZQ4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:56:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57680 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2GZQ4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:56:20 -0400
Message-ID: <501176AF.3000607@cantab.net>
Date: Thu, 26 Jul 2012 17:56:15 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Ian.Campbell@citrix.com, arnd@arndb.de,
        konrad.wilk@oracle.com, catalin.marinas@arm.com, tim@xen.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Xen-devel] [PATCH 02/24] xen/arm: hypercalls
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/12 16:33, Stefano Stabellini wrote:
> 
> + * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
> + * hypercall tag.

Is this number, 0xea1, assigned to Xen by some external body?

David
