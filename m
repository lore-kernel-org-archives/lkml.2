Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3AHMfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 07:35:33 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:50313 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3AHMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 07:35:31 -0500
Message-ID: <50EC128C.9060602@mvista.com>
Date: Tue, 08 Jan 2013 16:35:24 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: xhci: fix incorrect bit test
References: <1357616371-20689-1-git-send-email-nickolai@csail.mit.edu>
In-Reply-To: <1357616371-20689-1-git-send-email-nickolai@csail.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-01-2013 7:39, Nickolai Zeldovich wrote:

> Fix incorrect bit test that originally showed up in
> 4ee823b83bc9851743fab756c76b27d6a1e2472b: use '&' instead of '&&'.

    Please also specify the summary of that commit in parens (or however you 
like).

> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>

WBR, Sergei

