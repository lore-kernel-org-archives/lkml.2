Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0JGXtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:49:11 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:49406 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0JGXtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:49:09 -0400
Message-ID: <4CAE5C71.50304@linux.vnet.ibm.com>
Date: Thu, 07 Oct 2010 20:49:05 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Nicolas Kaiser <nikai@nikai.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ehea: simplify conditional
References: <20101008011450.0126ffc0@absol.kitzblitz>
In-Reply-To: <20101008011450.0126ffc0@absol.kitzblitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 08:14 PM, Nicolas Kaiser wrote:
> Simplify: ((a&&  b) || (!a&&  !b)) =>  (a == b)
>
> Signed-off-by: Nicolas Kaiser<nikai@nikai.net>
Acked-by: Breno Leitao <leitao@linux.vnet.ibm.com>

