Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab0JFOCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 10:02:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39087 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759013Ab0JFOCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 10:02:17 -0400
Message-ID: <4CAC8169.2060400@cs.helsinki.fi>
Date: Wed, 06 Oct 2010 17:02:17 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [UnifiedV4 02/16] slub: Move functions to reduce #ifdefs
References: <20101005185725.088808842@linux.com> <20101005185812.949429401@linux.com>
In-Reply-To: <20101005185812.949429401@linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.10.2010 21.57, Christoph Lameter wrote:
> There is a lot of #ifdef/#endifs that can be avoided if functions would be in different
> places. Move them around and reduce #ifdef.
>
> Signed-off-by: Christoph Lameter<cl@linux.com>

I applied this patch. Thanks!
