Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1LSUxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:53:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63454 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab1LSUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:53:17 -0500
Date: Mon, 19 Dec 2011 12:53:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Ryota Ozaki <ozaki.ryota@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-mm@kvack.org,
        stable@kernel.org
Subject: Re: [PATCH][RESEND] mm: Fix off-by-one bug in print_nodes_state
In-Reply-To: <4EEE6DC0.2030007@gmail.com>
Message-ID: <alpine.DEB.2.00.1112191252130.28684@chino.kir.corp.google.com>
References: <1324209529-15892-1-git-send-email-ozaki.ryota@gmail.com> <alpine.DEB.2.00.1112181439500.1364@chino.kir.corp.google.com> <4EEE6DC0.2030007@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-495150536-1324327973=:28684"
Content-ID: <alpine.DEB.2.00.1112191253010.28684@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-495150536-1324327973=:28684
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1112191253011.28684@chino.kir.corp.google.com>

On Sun, 18 Dec 2011, KOSAKI Motohiro wrote:

> Usually, /sys files don't output trailing '¥0'. And, '¥0' is not regular
> io friendly. So I can imagine some careless programmer think it is garbage. Is
> there any benefit to show trailing '¥0'?
> 

Nope, it could be removed since the buffer is allocated with 
get_zeroed_page().
--397155492-495150536-1324327973=:28684--
