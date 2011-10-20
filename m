Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab1JTQ43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:56:29 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:17372 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1JTQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:56:28 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4EA052B0.2080409@die-jansens.de>
Date: Thu, 20 Oct 2011 18:56:16 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arne Jansen <sensille@gmx.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] ulist: generic data structure to build unique lists
References: <1319122241-7222-1-git-send-email-sensille@gmx.net>
In-Reply-To: <1319122241-7222-1-git-send-email-sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.10.2011 16:50, Arne Jansen wrote:

> + * This function is used to iterate an ulist. The iteration is started with
> + * @prev = %NULL. It returns the next element from the ulist or %NULL when the
> + * end is reached. No guarantee is made with respect to the order in which
> + * the elements are returned. They might neither be returned in order of
> + * addition nor in ascending order.
> + * It is allowed to call ulist_add during an enumeration. Newly added items
> + * are guaranteed to show up in the running enumeration.

Thinking twice about it this guarantee most probably implies that the
items are returned  in order of addition. This is currently the case.

> + */
